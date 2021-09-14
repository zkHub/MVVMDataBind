//
//  NSObject+WXDataBind.m
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import "NSObject+WXDataBind.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WXDBWatcher.h"
#import <UIKit/UIKit.h>


@interface NSObject ()
@property (nonatomic,strong) NSMutableDictionary <NSString*,WXDBWatcher*> *depList;

@end


@implementation NSObject (WXDataBind)

- (BOOL)db_isDidChanged {
    NSNumber *boolValue = objc_getAssociatedObject(self, _cmd);
    return [boolValue boolValue];
}

- (void)setDb_isDidChanged:(BOOL)db_isDidChanged {
    objc_setAssociatedObject(self, @selector(db_isDidChanged), @(db_isDidChanged), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDepList:(NSMutableDictionary<NSString *,WXDBWatcher *> *)depList {
    objc_setAssociatedObject(self, @selector(depList), depList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary<NSString *,WXDBWatcher *> *)depList {
    return objc_getAssociatedObject(self, @selector(depList));
}


- (WXDBWatcher *)addBindObserverWithKeyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock {
    
    NSString *capitalStr = [NSString stringWithFormat:@"%@%@", [[keyPath substringToIndex:1] uppercaseString], [keyPath substringFromIndex:1]];
    const char * swizzledSELName = [[NSString stringWithFormat:@"wx_set%@:", capitalStr] cStringUsingEncoding:NSUTF8StringEncoding];
    SEL swizzledSEL = sel_registerName(swizzledSELName);
    SEL originalSEL = NSSelectorFromString([NSString stringWithFormat:@"set%@:", capitalStr]);
    
    Method originalMethod = class_getInstanceMethod(self.class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(self.class, swizzledSEL);
    if (!swizzledMethod && originalMethod) {
        char *methodArgumentType = method_copyArgumentType(originalMethod, 2);
        char type = methodArgumentType[0];
        IMP swizzledImp = nil;
        switch (type) {
            case 'c':{
                swizzledImp = (IMP)wx_setCharValue;
            } break;
            case 'i':{
                swizzledImp = (IMP)wx_setIntValue;
            } break;
            case 's':{
                swizzledImp = (IMP)wx_setShortValue;
            } break;
            case 'l':{
                swizzledImp = (IMP)wx_setLongValue;
            } break;
            case 'q':{
                swizzledImp = (IMP)wx_setLongLongValue;
            } break;
            case 'C':{
                swizzledImp = (IMP)wx_setUnsignedCharValue;
            } break;
            case 'I':{
                swizzledImp = (IMP)wx_setUnsignedIntValue;
            } break;
            case 'S':{
                swizzledImp = (IMP)wx_setUnsignedShortValue;
            } break;
            case 'L':{
                swizzledImp = (IMP)wx_setUnsignedLongValue;
            } break;
            case 'Q':{
                swizzledImp = (IMP)wx_setUnsignedLongLongValue;
            } break;
            case 'f':{
                swizzledImp = (IMP)wx_setFloatValue;
            } break;
            case 'd':{
                swizzledImp = (IMP)wx_setDoubleValue;
            } break;
            case 'B':{
                swizzledImp = (IMP)wx_setBoolValue;
            } break;
            case '@':{
                swizzledImp = (IMP)wx_setObjectValue;
            } break;
            default:
                break;
        }
        class_replaceMethod(self.class, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        class_replaceMethod(self.class, originalSEL, swizzledImp, method_getTypeEncoding(originalMethod));
    }
    //给key关联 dep
    WXDBWatcher *dep = [[WXDBWatcher alloc] initWithTarget:self keyPath:keyPath convertBlock:convertBlock];
    [self addDep:dep key:[self depKeyWithTarget:self keyPath:keyPath]];
    return dep;
}

#pragma mark - 遍历方法
- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@-%@-%p",cls,NSStringFromSelector(sel),imp);
    }
    free(methodList);
}
#pragma mark - 遍历属性-ivar
- (void)printClassAllIvar:(Class)cls{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"%@-%@",cls,ivarName);
    }
    free(ivars);
}

- (WXDBWatcher *)getDepWithSELStr:(NSString *)selStr
{
    WXDBWatcher *dep = nil;
    selStr = [self depKeyWithTarget:self keyPath:[self getKeyPathWithSELStr:selStr]];
    dep = [self depForKey:selStr];
    return dep;
}

- (NSString *)getKeyPathWithSELStr:(NSString *)selStr {
    if([selStr hasPrefix:@"set"]){
        selStr = [selStr stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
        selStr = [selStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[selStr substringToIndex:1] lowercaseString]];
        selStr = [selStr substringWithRange:NSMakeRange(0, selStr.length - 1)];
    }
    return selStr;
}

- (NSString *)depKeyWithTarget:(id)target keyPath:(NSString *)keyPath {
    return [NSString stringWithFormat:@"%@_%@", @([target hash]), keyPath];
}

- (BOOL)addDep:(WXDBWatcher *)dep key:(NSString *)key {
    if(dep && key){
        if (!self.depList) {
            self.depList = [NSMutableDictionary new];
        }
        [self.depList setObject:dep forKey:key];
        return YES;
    }
    return NO;
}

- (void)removeDepForKey:(NSString *)key {
    [self.depList removeObjectForKey:key];
}

- (WXDBWatcher *)depForKey:(NSString *)key {
    if(key){
        return [self.depList objectForKey:key];
    }
    return nil;
}



//MARK: - typeEncoding
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
// c
void wx_setCharValue(id receiver, SEL selecter, char value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// i
void wx_setIntValue(id receiver, SEL selecter, int value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// s
void wx_setShortValue(id receiver, SEL selecter, short value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// l
void wx_setLongValue(id receiver, SEL selecter, long value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// q
void wx_setLongLongValue(id receiver, SEL selecter, long long value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// C
void wx_setUnsignedCharValue(id receiver, SEL selecter, unsigned char value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// I
void wx_setUnsignedIntValue(id receiver, SEL selecter, unsigned int value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// S
void wx_setUnsignedShortValue(id receiver, SEL selecter, unsigned short value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// L
void wx_setUnsignedLongValue(id receiver, SEL selecter, unsigned long value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// Q
void wx_setUnsignedLongLongValue(id receiver, SEL selecter, unsigned long long value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// f
void wx_setFloatValue(id receiver, SEL selecter, float value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// d
void wx_setDoubleValue(id receiver, SEL selecter, double value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// B
void wx_setBoolValue(id receiver, SEL selecter, bool value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}
// @
void wx_setObjectValue(id receiver, SEL selecter, id value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}


- (void)wx_invokeWithSEL:(SEL)selecter argument:(void *)argument {
    const char * swizzledSELName = [[NSString stringWithFormat:@"wx_%@", NSStringFromSelector(selecter)] cStringUsingEncoding:NSUTF8StringEncoding];
    SEL swizzledSEL = sel_registerName(swizzledSELName);
    if ([self respondsToSelector:swizzledSEL]) {
        NSMethodSignature *signature = [self methodSignatureForSelector:swizzledSEL];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = self;
        invocation.selector = swizzledSEL;
        [invocation setArgument:argument atIndex:2];
        [invocation invoke];
        WXDBWatcher *dep = [self getDepWithSELStr:NSStringFromSelector(selecter)];
        [dep notify];
    }
}

@end
