//
//  WXDBObserver.m
//  mvvmTest
//
//  Created by zk on 2021/9/6.
//

#import "WXDBObserver.h"
#import "NSObject+WXDataBind.h"
#import "WXDBWatcher.h"
#import "UIControl+WXDataBind.h"


#define KVOSwitch 0


@interface WXDBObserver ()<VupDepDelegate>
@property (nonatomic, strong) NSMutableDictionary<NSString *, WXDBWatcher *> *watcherMaps;

@end


@implementation WXDBObserver

- (instancetype)init {
    if (self = [super init]) {
        self.watcherMaps = [NSMutableDictionary new];
    }
    return self;
}

- (NSString *)depKeyWithTarget:(id)target keyPath:(NSString *)keyPath {
    return [NSString stringWithFormat:@"%@_%@", @([target hash]), keyPath];
}

#if KVOSwitch
- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock {
    NSString *depKey = [self depKeyWithTarget:target keyPath:keyPath];
    if ([self.watcherMaps.allKeys containsObject:depKey]) {
        [self.watcherMaps removeObjectForKey:depKey];
    }
    [target addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:nil];
    VueWatcher *watcher = [[VueWatcher alloc] initWithTarget:target keyPath:keyPath convertBlock:nil];
    watcher.observer = self;
    [self.watcherMaps setObject:watcher forKey:depKey];
}

- (void)bindWithTarget:(UIControl *)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)controlEvent convertBlock:(VueDBAnyBlock)convertBlock {
    NSString *depKey = [self depKeyWithTarget:target keyPath:keyPath];
    if ([self.watcherMaps.allKeys containsObject:depKey]) {
        [self.watcherMaps removeObjectForKey:depKey];
    }
    [target addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:nil];
    VueWatcher *watcher = [[VueWatcher alloc] initWithTarget:target keyPath:keyPath convertBlock:nil];
    watcher.observer = self;
    [self.watcherMaps setObject:watcher forKey:depKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    NSString *depKey = [self depKeyWithTarget:object keyPath:keyPath];
    if ([self.watcherMaps.allKeys containsObject:depKey]) {
        VueWatcher *watcher = [self.watcherMaps objectForKey:depKey];
        [watcher notify];
    }
}

#else
- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock {
    NSString *depKey = [self depKeyWithTarget:target keyPath:keyPath];
    if (![self.watcherMaps.allKeys containsObject:depKey]) {
        WXDBWatcher *dep = [target addBindObserverWithKeyPath:keyPath convertBlock:convertBlock];
        dep.observer = self;
        if (dep) {
            [self.watcherMaps setObject:dep forKey:depKey];
        }
    }
}

- (void)bindWithTarget:(UIControl *)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)controlEvent convertBlock:(VueDBAnyBlock)convertBlock {
    NSString *depKey = [self depKeyWithTarget:target keyPath:keyPath];
    if (![self.watcherMaps.allKeys containsObject:depKey]) {
        WXDBWatcher *dep = [target addBindUIObserverWithKeyPath:keyPath forControlEvents:controlEvent convertBlock:convertBlock];
        dep.observer = self;
        [self.watcherMaps setObject:dep forKey:depKey];
    }
}
#endif

//MARK: - observerDelegate
- (void)updateValue:(id)value watcher:(WXDBWatcher *)watcher {
    for (NSString *key in self.watcherMaps.allKeys) {
        WXDBWatcher *tempWatcher = [self.watcherMaps objectForKey:key];
        if (!tempWatcher.target) {
            [self.watcherMaps removeObjectForKey:key];
            continue;
        }
        if (tempWatcher != watcher) {
            [tempWatcher updateValue:value];
        }
    }
}


//MARK: - classMethod
+ (VueDBOberverBlock)bind {
    return ^WXDBObserver *(id target, NSString *keyPath) {
        WXDBObserver *db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath convertBlock:nil];
        return db;
    };
}

+ (VueDBOberverUIBlock)bindUI {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event) {
        WXDBObserver *db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:nil];
        return db;
    };
}

+ (VueDBOberverConvertBlock)bindConvert {
    return ^WXDBObserver *(id target, NSString *keyPath, VueDBAnyBlock block) {
        WXDBObserver *db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath convertBlock:block];
        return db;
    };
}

+ (VueDBOberverUIConvertBlock)bindUIConvert {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event, VueDBAnyBlock block) {
        WXDBObserver *db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:block];
        return db;
    };
}

//MARK: - instenceMethod
- (VueDBOberverBlock)bind {
    return ^WXDBObserver *(id target, NSString *keyPath) {
        [self bindWithTarget:target keyPath:keyPath convertBlock:nil];
        return self;
    };
}

- (VueDBOberverUIBlock)bindUI {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event) {
        [self bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:nil];
        return self;
    };
}

- (VueDBOberverConvertBlock)bindConvert {
    return ^WXDBObserver *(id target, NSString *keyPath, VueDBAnyBlock block) {
        [self bindWithTarget:target keyPath:keyPath convertBlock:block];
        return self;
    };
}

- (VueDBOberverUIConvertBlock)bindUIConvert {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event, VueDBAnyBlock block) {
        [self bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:block];
        return self;
    };
}

- (void)dealloc {
    if (self.watcherMaps) {
        [self.watcherMaps removeAllObjects];
    }
}

@end
