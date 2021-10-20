//
//  UIControl+WXDataBind.m
//  mvvmTest
//
//  Created by zk on 2021/9/8.
//

#import "UIControl+WXDataBind.h"
#import <objc/runtime.h>
#import "WXDBObserverContainer.h"
#import "WXDBObserver.h"

@interface UIControl ()
@property(nonatomic, copy) NSString *db_ctrlBindKeyPath;

@end


@implementation UIControl (WXDataBind)

- (NSString *)db_ctrlBindKeyPath {
    return objc_getAssociatedObject(self, @selector(db_ctrlBindKeyPath));
}

- (void)setDb_ctrlBindKeyPath:(NSString *)db_ctrlBindKeyPath {
    objc_setAssociatedObject(self, @selector(db_ctrlBindKeyPath), db_ctrlBindKeyPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (WXDBWatcher *)db_addBindUIObserver:(WXDBObserver *)observer keyPath:(NSString *)keyPath forControlEvents:(UIControlEvents)controlEvent convertBlock:(WXDBAnyBlock)convertBlock {
    if (!self.db_observerContainer) {
        self.db_observerContainer = [WXDBObserverContainer new];
    }
    if (![self.db_observerContainer containsObserver:observer]) {
        [self.db_observerContainer addObserver:observer];
    }
    [self addTarget:self action:@selector(valueChange:) forControlEvents:(controlEvent)];
    WXDBWatcher *watcher = [[WXDBWatcher alloc] initWithTarget:self keyPath:keyPath convertBlock:convertBlock];
    [self db_setWatcher:watcher forKey:[self db_watcherKeyWithKeyPath:keyPath]];
    self.db_ctrlBindKeyPath = keyPath;
    return watcher;
}

- (void)valueChange:(UIControl *)target {
    WXDBWatcher *watcher = [self db_watcherForKey:[self db_watcherKeyWithKeyPath:self.db_ctrlBindKeyPath]];
    [watcher notify];
}




@end
