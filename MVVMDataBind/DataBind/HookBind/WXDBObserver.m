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

#if KVOSwitch
- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(WXDBAnyBlock)convertBlock {
    NSString *watcherKey = [target watcherKeyWithKeyPath:keyPath];
    if ([self.watcherMaps.allKeys containsObject:watcherKey]) {
        [self.watcherMaps removeObjectForKey:watcherKey];
    }
    [target addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:nil];
    VueWatcher *watcher = [[VueWatcher alloc] initWithTarget:target keyPath:keyPath convertBlock:nil];
    watcher.observer = self;
    [self.watcherMaps setObject:watcher forKey:watcherKey];
}

- (void)bindWithTarget:(UIControl *)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)controlEvent convertBlock:(WXDBAnyBlock)convertBlock {
    NSString *watcherKey = [target watcherKeyWithKeyPath:keyPath];
    if ([self.watcherMaps.allKeys containsObject:watcherKey]) {
        [self.watcherMaps removeObjectForKey:watcherKey];
    }
    [target addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:nil];
    VueWatcher *watcher = [[VueWatcher alloc] initWithTarget:target keyPath:keyPath convertBlock:nil];
    watcher.observer = self;
    [self.watcherMaps setObject:watcher forKey:watcherKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    NSString *watcherKey = [target watcherKeyWithKeyPath:keyPath];
    if ([self.watcherMaps.allKeys containsObject:watcherKey]) {
        VueWatcher *watcher = [self.watcherMaps objectForKey:watcherKey];
        [watcher notify];
    }
}

#else
- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(WXDBAnyBlock)convertBlock {
    NSString *watcherKey = [target watcherKeyWithKeyPath:keyPath];
    if (![self.watcherMaps.allKeys containsObject:watcherKey]) {
        WXDBWatcher *wathcer = [target addBindObserverWithKeyPath:keyPath convertBlock:convertBlock];
        wathcer.observer = self;
        if (wathcer) {
            [self.watcherMaps setObject:wathcer forKey:watcherKey];
        }
    }
}

- (void)bindWithTarget:(UIControl *)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)controlEvent convertBlock:(WXDBAnyBlock)convertBlock {
    NSString *watcherKey = [target watcherKeyWithKeyPath:keyPath];
    if (![self.watcherMaps.allKeys containsObject:watcherKey]) {
        WXDBWatcher *wathcer = [target addBindUIObserverWithKeyPath:keyPath forControlEvents:controlEvent convertBlock:convertBlock];
        wathcer.observer = self;
        if (wathcer) {
            [self.watcherMaps setObject:wathcer forKey:watcherKey];
        }
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
        if (![tempWatcher.watcherKey isEqualToString:watcher.watcherKey]) {
            [tempWatcher updateValue:value];
        }
    }
}

- (void)removeWathcer:(WXDBWatcher *)watcher {
    if (watcher.watcherKey) {
        [self.watcherMaps removeObjectForKey:watcher.watcherKey];
    }
}


//MARK: - classMethod
+ (WXDBOberverBlock)bind {
    return ^WXDBObserver *(id target, NSString *keyPath) {
        WXDBObserver *db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath convertBlock:nil];
        return db;
    };
}

+ (WXDBOberverUIBlock)bindUI {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event) {
        WXDBObserver *db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:nil];
        return db;
    };
}

+ (WXDBOberverConvertBlock)bindConvert {
    return ^WXDBObserver *(id target, NSString *keyPath, WXDBAnyBlock block) {
        WXDBObserver *db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath convertBlock:block];
        return db;
    };
}

+ (WXDBOberverUIConvertBlock)bindUIConvert {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event, WXDBAnyBlock block) {
        WXDBObserver *db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:block];
        return db;
    };
}

//MARK: - instenceMethod
- (WXDBOberverBlock)bind {
    return ^WXDBObserver *(id target, NSString *keyPath) {
        [self bindWithTarget:target keyPath:keyPath convertBlock:nil];
        return self;
    };
}

- (WXDBOberverUIBlock)bindUI {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event) {
        [self bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:nil];
        return self;
    };
}

- (WXDBOberverConvertBlock)bindConvert {
    return ^WXDBObserver *(id target, NSString *keyPath, WXDBAnyBlock block) {
        [self bindWithTarget:target keyPath:keyPath convertBlock:block];
        return self;
    };
}

- (WXDBOberverUIConvertBlock)bindUIConvert {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event, WXDBAnyBlock block) {
        [self bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:block];
        return self;
    };
}

- (void)dealloc {
    if (self.watcherMaps) {
        for (NSString *key in self.watcherMaps.allKeys) {
            WXDBWatcher *watcher = [self.watcherMaps objectForKey:key];
            if (watcher.target) {
                [watcher.target removeWatcherForKey:watcher.watcherKey];
            }
        }
        [self.watcherMaps removeAllObjects];
    }
}

@end
