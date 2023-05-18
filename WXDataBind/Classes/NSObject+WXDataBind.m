//
//  NSObject+WXDataBind.m
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import "NSObject+WXDataBind.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>


@implementation NSObject (WXDataBind)

//MARK: - setter getter
- (WXDataBindContainer *)db_watcherContainer {
    return objc_getAssociatedObject(self, @selector(db_watcherContainer));
}
- (void)setDb_watcherContainer:(WXDataBindContainer *)db_watcherContainer {
    objc_setAssociatedObject(self, @selector(db_watcherContainer), db_watcherContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WXDataBindContainer *)db_observerContainer {
    return objc_getAssociatedObject(self, @selector(db_observerContainer));
}
- (void)setDb_observerContainer:(WXDataBindContainer *)db_observerContainer {
    objc_setAssociatedObject(self, @selector(db_observerContainer), db_observerContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//MARK: - public method
- (WXDBWatcher *)db_addBindObserver:(WXDBObserver *)observer keyPath:(NSString *)keyPath filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {

    NSString *capitalStr = [NSString stringWithFormat:@"%@%@", [[keyPath substringToIndex:1] uppercaseString], [keyPath substringFromIndex:1]];
    const char * swizzledSELName = [[NSString stringWithFormat:@"db_set%@:", capitalStr] cStringUsingEncoding:NSUTF8StringEncoding];
    SEL swizzledSEL = sel_registerName(swizzledSELName);
    Method swizzledMethod = class_getInstanceMethod(self.class, swizzledSEL);

    if (!swizzledMethod) {
        SEL originalSEL = NSSelectorFromString([NSString stringWithFormat:@"set%@:", capitalStr]);
        Method originalMethod = class_getInstanceMethod(self.class, originalSEL);
        if (originalMethod) {
            char *methodArgumentType = method_copyArgumentType(originalMethod, 2);
            char type = methodArgumentType[0];
            IMP swizzledImp = nil;
            switch (type) {
                case 'c':{
                    swizzledImp = (IMP)db_setCharValue;
                } break;
                case 'i':{
                    swizzledImp = (IMP)db_setIntValue;
                } break;
                case 's':{
                    swizzledImp = (IMP)db_setShortValue;
                } break;
                case 'l':{
                    swizzledImp = (IMP)db_setLongValue;
                } break;
                case 'q':{
                    swizzledImp = (IMP)db_setLongLongValue;
                } break;
                case 'C':{
                    swizzledImp = (IMP)db_setUnsignedCharValue;
                } break;
                case 'I':{
                    swizzledImp = (IMP)db_setUnsignedIntValue;
                } break;
                case 'S':{
                    swizzledImp = (IMP)db_setUnsignedShortValue;
                } break;
                case 'L':{
                    swizzledImp = (IMP)db_setUnsignedLongValue;
                } break;
                case 'Q':{
                    swizzledImp = (IMP)db_setUnsignedLongLongValue;
                } break;
                case 'f':{
                    swizzledImp = (IMP)db_setFloatValue;
                } break;
                case 'd':{
                    swizzledImp = (IMP)db_setDoubleValue;
                } break;
                case 'B':{
                    swizzledImp = (IMP)db_setBoolValue;
                } break;
                case '@':{
                    swizzledImp = (IMP)db_setObjectValue;
                } break;
                default:
                    break;
            }
            if (!swizzledImp) {
                return nil;
            }
            class_replaceMethod(self.class, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            class_replaceMethod(self.class, originalSEL, swizzledImp, method_getTypeEncoding(originalMethod));
        }
    }
    
    // target持有observer
    [self db_setObserver:observer forKey:keyPath];
    
    // target持有watcher，每个对象的每个key对应唯一一个watcher
    WXDBWatcher *watcher = [[WXDBWatcher alloc] initWithTarget:self keyPath:keyPath filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
    [self db_setWatcher:watcher forKey:keyPath];
    return watcher;
}

- (NSString *)db_watcherKeyWithKeyPath:(NSString *)keyPath {
    return [NSString stringWithFormat:@"%@_%@", @([self hash]), keyPath];
}

- (NSString *)db_keyPathWithWatcherKey:(NSString *)watcherKey {
    return [watcherKey componentsSeparatedByString:@"_"].lastObject;
}

//MARK: - observer
- (void)db_setObserver:(WXDBObserver *)observer forKey:(NSString *)key {
    if (!self.db_observerContainer) {
        self.db_observerContainer = [WXDataBindContainer new];
    }
    [self.db_observerContainer setObject:observer forKey:key];
}

- (WXDBObserver *)db_observerForKey:(NSString *)key {
    return [self.db_observerContainer objectForKey:key];
}

//MARK: - watcher
- (void)db_setWatcher:(WXDBWatcher *)watcher forKey:(NSString *)key {
    if (!self.db_watcherContainer) {
        self.db_watcherContainer = [WXDataBindContainer new];
    }
    [self.db_watcherContainer setObject:watcher forKey:key];
}

- (WXDBWatcher *)db_watcherForKey:(NSString *)key {
    return [self.db_watcherContainer objectForKey:key];
}

- (void)db_removeDataBindForKey:(NSString *)key {
    [self.db_observerContainer removeObjectForKey:key];
    [self.db_watcherContainer removeObjectForKey:key];
}

- (void)db_removeAllDataBinds {
    [self.db_observerContainer removeAllObjects];
    [self.db_watcherContainer removeAllObjects];
}


//MARK: - typeEncoding
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
// c
void db_setCharValue(id receiver, SEL selecter, char value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// i
void db_setIntValue(id receiver, SEL selecter, int value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// s
void db_setShortValue(id receiver, SEL selecter, short value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// l
void db_setLongValue(id receiver, SEL selecter, long value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// q
void db_setLongLongValue(id receiver, SEL selecter, long long value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// C
void db_setUnsignedCharValue(id receiver, SEL selecter, unsigned char value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// I
void db_setUnsignedIntValue(id receiver, SEL selecter, unsigned int value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// S
void db_setUnsignedShortValue(id receiver, SEL selecter, unsigned short value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// L
void db_setUnsignedLongValue(id receiver, SEL selecter, unsigned long value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// Q
void db_setUnsignedLongLongValue(id receiver, SEL selecter, unsigned long long value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// f
void db_setFloatValue(id receiver, SEL selecter, float value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// d
void db_setDoubleValue(id receiver, SEL selecter, double value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// B
void db_setBoolValue(id receiver, SEL selecter, bool value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}
// @
void db_setObjectValue(id receiver, SEL selecter, id value) {
    [receiver db_invokeWithSEL:selecter argument:&value];
}

//MARK: - method hook
- (void)db_invokeWithSEL:(SEL)selecter argument:(void *)argument {
    const char * swizzledSELName = [[NSString stringWithFormat:@"db_%@", NSStringFromSelector(selecter)] cStringUsingEncoding:NSUTF8StringEncoding];
    SEL swizzledSEL = sel_registerName(swizzledSELName);
    if ([self respondsToSelector:swizzledSEL]) {
        NSMethodSignature *signature = [self methodSignatureForSelector:swizzledSEL];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = self;
        invocation.selector = swizzledSEL;
        [invocation setArgument:argument atIndex:2];
        [invocation invoke];
        WXDBWatcher *watcher = [self db_getWatcherWithSELStr:NSStringFromSelector(selecter)];
        [watcher notify];
    }
}

- (WXDBWatcher *)db_getWatcherWithSELStr:(NSString *)selStr {
    return [self db_watcherForKey:[self db_getKeyPathWithSELStr:selStr]];
}

- (NSString *)db_getKeyPathWithSELStr:(NSString *)selStr {
    if([selStr hasPrefix:@"set"]){
        selStr = [selStr substringWithRange:NSMakeRange(3, selStr.length - 4)];
        selStr = [NSString stringWithFormat:@"%@%@", [[selStr substringToIndex:1] lowercaseString], [selStr substringFromIndex:1]];
    }
    return selStr;
}

//MARK: - bind notificationName
- (WXDBWatcher *)db_addBindObserver:(WXDBObserver *)observer keyPath:(NSString *)keyPath notificationName:(NSNotificationName)notificationName filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {
    
    const char * swizzledSELName = [[NSString stringWithFormat:@"db_notification_%@", keyPath] cStringUsingEncoding:NSUTF8StringEncoding];
    SEL swizzledSEL = sel_registerName(swizzledSELName);
    if (!class_getInstanceMethod(self.class, swizzledSEL)) {
        IMP swizzledImp = (IMP)db_notificationAction;
        class_addMethod(self.class, swizzledSEL, swizzledImp, "v@:");
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:swizzledSEL name:notificationName object:self];
    
    return [self db_addBindObserver:observer keyPath:keyPath filterBlock:filterBlock convertBlock:convertBlock didChangeBlock:didChangeBlock];
}


void db_notificationAction(id receiver, SEL selecter) {
    [receiver db_invokeNotificationWithSEL:selecter];
}

- (void)db_invokeNotificationWithSEL:(SEL)selecter {
    NSString *keyPath = NSStringFromSelector(selecter);
    if ([keyPath hasPrefix:@"db_notification_"]) {
        keyPath = [keyPath substringFromIndex:16];
    }
    WXDBWatcher *watcher = [self db_watcherForKey:keyPath];
    [watcher notify];
}


@end
