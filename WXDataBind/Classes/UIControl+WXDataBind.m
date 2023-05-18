//
//  UIControl+WXDataBind.m
//  mvvmTest
//
//  Created by zk on 2021/9/8.
//

#import "UIControl+WXDataBind.h"
#import <objc/runtime.h>


@implementation UIControl (WXDataBind)

- (WXDBWatcher *)db_addBindObserver:(WXDBObserver *)observer keyPath:(NSString *)keyPath controlEvents:(UIControlEvents)controlEvents filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {
    
    const char * swizzledSELName = [[NSString stringWithFormat:@"db_event_%@", keyPath] cStringUsingEncoding:NSUTF8StringEncoding];
    SEL swizzledSEL = sel_registerName(swizzledSELName);
    if (!class_getInstanceMethod(self.class, swizzledSEL)) {
        IMP swizzledImp = (IMP)db_controlEventAction;
        class_addMethod(self.class, swizzledSEL, swizzledImp, "v@:");
    }
    [self addTarget:self action:swizzledSEL forControlEvents:(controlEvents)];

    return [self db_addBindObserver:observer keyPath:keyPath filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
}


void db_controlEventAction(id receiver, SEL selecter) {
    [receiver db_invokeEventActionWithSEL:selecter];
}

- (void)db_invokeEventActionWithSEL:(SEL)selecter {
    NSString *keyPath = NSStringFromSelector(selecter);
    if ([keyPath hasPrefix:@"db_event_"]) {
        keyPath = [keyPath substringFromIndex:9];
    }
    WXDBWatcher *watcher = [self db_watcherForKey:keyPath];
    [watcher notify];
}


@end
