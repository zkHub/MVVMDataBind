//
//  VueObserver.m
//  mvvmTest
//
//  Created by zk on 2021/9/6.
//

#import "VueObserver.h"
#import "NSObject+DataBind.h"
#import "VueWatcher.h"
#import "NSObject+DataBind.h"
#import "UIControl+DataBind.h"

@interface VueObserver ()<VupDepDelegate>
@property (nonatomic, strong) NSMutableDictionary<NSString *, VueWatcher *> *watcherMaps;

@end


@implementation VueObserver

- (instancetype)init {
    if (self = [super init]) {
        self.watcherMaps = [NSMutableDictionary new];
    }
    return self;
}



- (NSString *)depKeyWithTarget:(id)target keyPath:(NSString *)keyPath {
    return [NSString stringWithFormat:@"%@_%@", @([target hash]), keyPath];
}

- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock {
    NSString *depKey = [self depKeyWithTarget:target keyPath:keyPath];
    if (![self.watcherMaps.allKeys containsObject:depKey]) {
        VueWatcher *dep = [target addBindObserverWithKeyPath:keyPath convertBlock:convertBlock];
        dep.observer = self;
        if (dep) {
            [self.watcherMaps setObject:dep forKey:depKey];
        }
    }
}

- (void)bindWithTarget:(UIControl *)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)controlEvent convertBlock:(VueDBAnyBlock)convertBlock {
    NSString *depKey = [self depKeyWithTarget:target keyPath:keyPath];
    if (![self.watcherMaps.allKeys containsObject:depKey]) {
        VueWatcher *dep = [target addBindUIObserverWithKeyPath:keyPath forControlEvents:controlEvent convertBlock:convertBlock];
        dep.observer = self;
        [self.watcherMaps setObject:dep forKey:depKey];
    }
}

- (void)updateValue:(id)value dep:(VueWatcher *)dep {
    for (VueWatcher *vueDep in self.watcherMaps.allValues) {
        if (vueDep != dep) {
            [vueDep updateValue:value];
        }
    }
}


//MARK: - classMethod
+ (VueDBOberverBlock)bind {
    return ^VueObserver *(id target, NSString *keyPath) {
        VueObserver *db = [VueObserver new];
        [db bindWithTarget:target keyPath:keyPath convertBlock:nil];
        return db;
    };
}

+ (VueDBOberverUIBlock)bindUI {
    return ^VueObserver *(id target, NSString *keyPath, UIControlEvents event) {
        VueObserver *db = [VueObserver new];
        [db bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:nil];
        return db;
    };
}

+ (VueDBOberverConvertBlock)bindConvert {
    return ^VueObserver *(id target, NSString *keyPath, VueDBAnyBlock block) {
        VueObserver *db = [VueObserver new];
        [db bindWithTarget:target keyPath:keyPath convertBlock:block];
        return db;
    };
}

+ (VueDBOberverUIConvertBlock)bindUIConvert {
    return ^VueObserver *(id target, NSString *keyPath, UIControlEvents event, VueDBAnyBlock block) {
        VueObserver *db = [VueObserver new];
        [db bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:block];
        return db;
    };
}

//MARK: - instenceMethod
- (VueDBOberverBlock)bind {
    return ^VueObserver *(id target, NSString *keyPath) {
        [self bindWithTarget:target keyPath:keyPath convertBlock:nil];
        return self;
    };
}

- (VueDBOberverUIBlock)bindUI {
    return ^VueObserver *(id target, NSString *keyPath, UIControlEvents event) {
        [self bindWithTarget:target keyPath:keyPath controlEvent:event convertBlock:nil];
        return self;
    };
}

- (VueDBOberverConvertBlock)bindConvert {
    return ^VueObserver *(id target, NSString *keyPath, VueDBAnyBlock block) {
        [self bindWithTarget:target keyPath:keyPath convertBlock:block];
        return self;
    };
}

- (VueDBOberverUIConvertBlock)bindUIConvert {
    return ^VueObserver *(id target, NSString *keyPath, UIControlEvents event, VueDBAnyBlock block) {
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
