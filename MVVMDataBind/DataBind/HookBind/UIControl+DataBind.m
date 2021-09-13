//
//  UIControl+DataBind.m
//  mvvmTest
//
//  Created by zk on 2021/9/8.
//

#import "UIControl+DataBind.h"
#import <objc/runtime.h>

@implementation UIControl (DataBind)

- (NSString *)db_ctrl_bindKeyPath {
    NSString *targetKeyHash = objc_getAssociatedObject(self, _cmd);
    return targetKeyHash?:@"";
}

- (void)setDb_ctrl_bindKeyPath:(NSString *)db_ctrl_bindKeyPath {
    objc_setAssociatedObject(self, @selector(db_ctrl_bindKeyPath), db_ctrl_bindKeyPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (VueWatcher *)addBindUIObserverWithKeyPath:(NSString *)keyPath forControlEvents:(UIControlEvents)controlEvent convertBlock:(VueDBAnyBlock)convertBlock {
    [self addTarget:self action:@selector(valueChange:) forControlEvents:(controlEvent)];
    VueWatcher *dep = [[VueWatcher alloc] initWithTarget:self keyPath:keyPath convertBlock:convertBlock];
    [self addDep:dep key:keyPath];
    self.db_ctrl_bindKeyPath = keyPath;
    return dep;
}

- (void)valueChange:(UIControl *)target {
    VueWatcher *dep = [self depForKey:self.db_ctrl_bindKeyPath];
    if (dep) {
        [dep notify];
    }
}




@end
