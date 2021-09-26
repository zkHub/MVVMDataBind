//
//  UIControl+WXDataBind.m
//  mvvmTest
//
//  Created by zk on 2021/9/8.
//

#import "UIControl+WXDataBind.h"
#import <objc/runtime.h>

@interface UIControl ()
@property(nonatomic, copy) NSString *db_ctrl_bindKeyPath;

@end


@implementation UIControl (WXDataBind)

- (NSString *)db_ctrl_bindKeyPath {
    NSString *targetKeyHash = objc_getAssociatedObject(self, _cmd);
    return targetKeyHash?:@"";
}

- (void)setDb_ctrl_bindKeyPath:(NSString *)db_ctrl_bindKeyPath {
    objc_setAssociatedObject(self, @selector(db_ctrl_bindKeyPath), db_ctrl_bindKeyPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (WXDBWatcher *)db_addBindUIObserverWithKeyPath:(NSString *)keyPath forControlEvents:(UIControlEvents)controlEvent convertBlock:(WXDBAnyBlock)convertBlock {
    [self addTarget:self action:@selector(valueChange:) forControlEvents:(controlEvent)];
    WXDBWatcher *watcher = [[WXDBWatcher alloc] initWithTarget:self keyPath:keyPath convertBlock:convertBlock];
    [self db_setWatcher:watcher forKey:[self db_watcherKeyWithKeyPath:keyPath]];
    self.db_ctrl_bindKeyPath = keyPath;
    return watcher;
}

- (void)valueChange:(UIControl *)target {
    WXDBWatcher *watcher = [self db_watcherForKey:[self db_watcherKeyWithKeyPath:self.db_ctrl_bindKeyPath]];
    if (watcher) {
        [watcher notify];
    }
}




@end
