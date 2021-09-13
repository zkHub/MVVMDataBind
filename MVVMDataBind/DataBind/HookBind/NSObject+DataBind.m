//
//  NSObject+DataBind.m
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import "NSObject+DataBind.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "VueWatcher.h"
#import <UIKit/UIKit.h>


@interface NSObject ()
@property (nonatomic,strong) NSMutableDictionary <NSString*,VueWatcher*> *depList;

@end


@implementation NSObject (DataBind)

- (BOOL)db_isDidChanged {
    NSNumber *boolValue = objc_getAssociatedObject(self, _cmd);
    return [boolValue boolValue];
}

- (void)setDb_isDidChanged:(BOOL)db_isDidChanged {
    objc_setAssociatedObject(self, @selector(db_isDidChanged), @(db_isDidChanged), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDepList:(NSMutableDictionary<NSString *,VueWatcher *> *)depList {
    objc_setAssociatedObject(self, @selector(depList), depList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary<NSString *,VueWatcher *> *)depList {
    return objc_getAssociatedObject(self, @selector(depList));
}


- (VueWatcher *)addBindObserverWithKeyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock {
    
    const char * swizzledSELName = [[NSString stringWithFormat:@"wx_set%@:", [keyPath capitalizedString]] cStringUsingEncoding:NSUTF8StringEncoding];
    SEL swizzledSEL = sel_registerName(swizzledSELName);
    SEL originalSEL = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [keyPath capitalizedString]]);
    
    Method originalMethod = class_getInstanceMethod(self.class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(self.class, swizzledSEL);
    if (!swizzledMethod && originalMethod) {
        char *methodArgumentType = method_copyArgumentType(originalMethod, 2);
        char type = methodArgumentType[0];
        IMP swizzledImp = (IMP)wx_setObject;
        if (type == '@') {
            swizzledImp = (IMP)wx_setObject;
        } else if (type == 'q') {
            swizzledImp = (IMP)wx_setLongLong;
        } else if (type == 'f') {
            swizzledImp = (IMP)wx_setFloat;
        }
        class_replaceMethod(self.class, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        class_replaceMethod(self.class, originalSEL, swizzledImp, method_getTypeEncoding(originalMethod));
    }
    //给key关联 dep
    VueWatcher *dep = [[VueWatcher alloc] initWithTarget:self keyPath:keyPath convertBlock:convertBlock];
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

- (VueWatcher *)getDepWithSELStr:(NSString *)selStr
{
    VueWatcher *dep = nil;
    if([selStr hasPrefix:@"set"]){
        selStr = [selStr stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
        selStr = [selStr stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[selStr substringToIndex:1] lowercaseString]];
        selStr = [selStr substringWithRange:NSMakeRange(0, selStr.length - 1)];
    }
    selStr = [self depKeyWithTarget:self keyPath:selStr];
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

- (BOOL)addDep:(VueWatcher *)dep key:(NSString *)key {
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

- (VueWatcher *)depForKey:(NSString *)key {
    if(key){
        return [self.depList objectForKey:key];
    }
    return nil;
}

void wx_setObject(id receiver, SEL selecter, id value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}

void wx_setLongLong(id receiver, SEL selecter, long long value) {
    [receiver wx_invokeWithSEL:selecter argument:&value];
}

void wx_setFloat(id receiver, SEL selecter, float value) {
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
        VueWatcher *dep = [self getDepWithSELStr:NSStringFromSelector(selecter)];
        [dep notify];
    }
}

@end
