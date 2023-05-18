//
//  WXDBObserver.m
//  mvvmTest
//
//  Created by zk on 2021/9/6.
//

#import "WXDBObserver.h"
#import "NSObject+WXDataBind.h"
#import "UIControl+WXDataBind.h"
#import "WXDBWatcher.h"


@interface WXDBObserver ()<WXDBWatcherDelegate>
@property (nonatomic, strong) NSMapTable<NSString *, WXDBWatcher *> *watcherMaps;
@property (nonatomic, strong) NSMapTable<NSString *, id> *targetMaps;

@end


@implementation WXDBObserver

static BOOL WXDataBind_KVO = NO;

//MARK: - classMethod

+ (void)UseKVOBind {
    if (@available(iOS 12.0, *)) {
        WXDataBind_KVO = YES;
    }
}

+ (WXDBOberverBlock)bind {
    return ^WXDBObserver *(id target, NSString *keyPath) {
        WXDBObserver *db = [target db_observerForKey:keyPath];
        if (db) {
            return db;
        }
        db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath filterBlock:nil convertBlock:nil didChangeBlock:nil];
        return db;
    };
}

+ (WXDBOberverProcessBlock)bindWithProcess {
    return ^WXDBObserver *(id target, NSString *keyPath, WXDBFilterBlock fBlock, WXDBConvertBlock cBlock, WXDBDidChangeBlock dBlock) {
        WXDBObserver *db = [target db_observerForKey:keyPath];
        if (db) {
            return db;
        }
        db = [WXDBObserver new];
        [db bindWithTarget:target keyPath:keyPath filterBlock:fBlock convertBlock:cBlock didChangeBlock:dBlock];
        return db;
    };
}

// 移除绑定
+ (void)removeDataBindForTarget:(id)target key:(NSString *)keyPath {
    [target db_removeDataBindForKey:keyPath];
}

+ (void)removeAllDataBindsForTarget:(id)target {
    [target db_removeAllDataBinds];
}

//MARK: - instenceMethod
- (WXDBOberverBlock)bind {
    return ^WXDBObserver *(id target, NSString *keyPath) {
        [self bindWithTarget:target keyPath:keyPath filterBlock:nil convertBlock:nil didChangeBlock:nil];
        return self;
    };
}

- (WXDBOberverProcessBlock)bindWithProcess {
    return ^WXDBObserver *(id target, NSString *keyPath, WXDBFilterBlock fBlock, WXDBConvertBlock cBlock, WXDBDidChangeBlock dBlock) {
        [self bindWithTarget:target keyPath:keyPath filterBlock:fBlock convertBlock:cBlock didChangeBlock:dBlock];
        return self;
    };
}

- (WXDBOberverEventBlock)bindEvent {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event) {
        [self bindWithTarget:target keyPath:keyPath controlEvents:event filterBlock:nil convertBlock:nil didChangeBlock:nil];
        return self;
    };
}

- (WXDBOberverEventProcessBlock)bindEventWithProcess {
    return ^WXDBObserver *(id target, NSString *keyPath, UIControlEvents event, WXDBFilterBlock fBlock, WXDBConvertBlock cBlock, WXDBDidChangeBlock dBlock) {
        [self bindWithTarget:target keyPath:keyPath controlEvents:event filterBlock:fBlock convertBlock:cBlock didChangeBlock:dBlock];
        return self;
    };
}

- (WXDBOberverNotifyBlock)bindNotify {
    return ^WXDBObserver *(id target, NSString *keyPath, NSNotificationName notificationName) {
        [self bindWithTarget:target keyPath:keyPath notificationName:notificationName filterBlock:nil convertBlock:nil didChangeBlock:nil];
        return self;
    };
}

- (WXDBOberverNotifyProcessBlock)bindNotifyWithProcess {
    return ^WXDBObserver *(id target, NSString *keyPath, NSNotificationName notificationName, WXDBFilterBlock fBlock, WXDBConvertBlock cBlock, WXDBDidChangeBlock dBlock) {
        [self bindWithTarget:target keyPath:keyPath notificationName:notificationName filterBlock:fBlock convertBlock:cBlock didChangeBlock:dBlock];
        return self;
    };
}

- (WXDBOberverBlock)db_bind {
    return [self bind];
}

- (WXDBOberverProcessBlock)db_bindWithProcess {
    return [self bindWithProcess];
}

- (WXDBOberverEventBlock)db_bindEvent {
    return [self bindEvent];
}

- (WXDBOberverEventProcessBlock)db_bindEventWithProcess {
    return [self bindEventWithProcess];
}

- (WXDBOberverNotifyBlock)db_bindNotify {
    return [self bindNotify];
}

- (WXDBOberverNotifyProcessBlock)db_bindNotifyWithProcess {
    return [self bindNotifyWithProcess];
}

//MARK: - init
- (instancetype)init {
    if (self = [super init]) {
        self.watcherMaps = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
        self.targetMaps = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

- (void)bindWithTarget:(NSObject *)target keyPath:(NSString *)keyPath filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {
    if (WXDataBind_KVO) {
        [self bindKVOWithTarget:target keyPath:keyPath filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
    } else {
        [self bindSetWithTarget:target keyPath:keyPath filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
    }
}

//MARK: - bindKVO
- (void)bindKVOWithTarget:(NSObject *)target keyPath:(NSString *)keyPath filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {
    [target addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:nil];
    // 保存observer及其关系
    [target db_setObserver:self forKey:keyPath];
    NSString *watcherKey = [target db_watcherKeyWithKeyPath:keyPath];
    [self.targetMaps setObject:target forKey:watcherKey];

    WXDBWatcher *watcher = [[WXDBWatcher alloc] initWithTarget:target keyPath:keyPath filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
    [target db_setWatcher:watcher forKey:keyPath];
    watcher.observer = self;
    if (watcher && watcherKey) {
        [self.watcherMaps setObject:watcher forKey:watcherKey];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *watcherKey = [object db_watcherKeyWithKeyPath:keyPath];
    WXDBWatcher *watcher = [self.watcherMaps objectForKey:watcherKey];
    [watcher notify];
}

- (void)dealloc {
    if (WXDataBind_KVO) {
        // 根据枚举器遍历值
        NSEnumerator *keyEnumerator = [self.targetMaps keyEnumerator];
        NSString *key;
        while (key = [keyEnumerator nextObject]) {
            id target = [self.targetMaps objectForKey:key];
            NSString *keyPath = [target db_keyPathWithWatcherKey:key];
            [target removeObserver:self forKeyPath:keyPath];
        }
    }
}

//MARK: - bindSet
- (void)bindSetWithTarget:(id)target keyPath:(NSString *)keyPath filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {
    WXDBWatcher *watcher = [target db_addBindObserver:self keyPath:keyPath filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
    watcher.observer = self;
    NSString *watcherKey = [target db_watcherKeyWithKeyPath:keyPath];
    if (watcher && watcherKey) {
        [self.watcherMaps setObject:watcher forKey:watcherKey];
    }
}

//MARK: - bindUIControlEvents
- (void)bindWithTarget:(UIControl *)target keyPath:(NSString *)keyPath controlEvents:(UIControlEvents)controlEvents filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {
    WXDBWatcher *watcher = [target db_addBindObserver:self keyPath:keyPath controlEvents:controlEvents filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
    watcher.observer = self;
    NSString *watcherKey = [target db_watcherKeyWithKeyPath:keyPath];
    if (watcher && watcherKey) {
        [self.watcherMaps setObject:watcher forKey:watcherKey];
    }
}

//MARK: - bindNSNotificationName
- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath notificationName:(NSNotificationName)notificationName filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {
    WXDBWatcher *watcher = [target db_addBindObserver:self keyPath:keyPath notificationName:notificationName filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
    watcher.observer = self;
    NSString *watcherKey = [target db_watcherKeyWithKeyPath:keyPath];
    if (watcher && watcherKey) {
        [self.watcherMaps setObject:watcher forKey:watcherKey];
    }
}

//MARK: - WXDBWatcherDelegate
- (void)updateValue:(id)value watcher:(WXDBWatcher *)watcher {
    // 根据枚举器遍历值
    NSEnumerator *objectEnumerator = [self.watcherMaps objectEnumerator];
    WXDBWatcher *tempWatcher;
    while (tempWatcher = [objectEnumerator nextObject]) {
        if (![tempWatcher.watcherKey isEqualToString:watcher.watcherKey]) {
            [tempWatcher updateValue:value];
        }
    }
}

@end
