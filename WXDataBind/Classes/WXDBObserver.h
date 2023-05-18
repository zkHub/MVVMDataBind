//
//  WXDBObserver.h
//  mvvmTest
//
//  Created by zk on 2021/9/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WXDBObserver;

NS_ASSUME_NONNULL_BEGIN

#define keyPathString(target, keyPath) (((void)(NO && ((void)target.keyPath, NO)), #keyPath))

#define WXDBBind(target, keyPath)                                       WXDBObserver.bind(target, @keyPathString(target, keyPath))
#define WXDBBindWithProcess(target, keyPath, fBlock, cBlock, dBlock)    WXDBObserver.bindWithProcess(target, @keyPathString(target, keyPath), fBlock, cBlock, dBlock)

#define WXDBRemoveBind(target, keyPath)         [WXDBObserver removeDataBindForTarget:target key:@keyPathString(target, keyPath)]
#define WXDBRemoveAllBinds(target)              [WXDBObserver removeAllDataBindsForTarget:target]

#define WXDataBindUseKVO                        [WXDBObserver UseKVOBind]

#define db_bind(target, keyPath)                                        bind(target, @keyPathString(target, keyPath))
#define db_bindWithProcess(target, keyPath, fBlock, cBlock, dBlock)     bindWithProcess(target, @keyPathString(target, keyPath), fBlock, cBlock, dBlock)

#define db_bindEvent(target, keyPath, event)                                        bindEvent(target, @keyPathString(target, keyPath), event)
#define db_bindEventWithProcess(target, keyPath, event, fBlock, cBlock, dBlock)     bindEventWithProcess(target, @keyPathString(target, keyPath), event, fBlock, cBlock, dBlock)

#define db_bindNotify(target, keyPath, notificationName)                                        bindNotify(target, @keyPathString(target, keyPath), notificationName)
#define db_bindNotifyWithProcess(target, keyPath, notificationName, fBlock, cBlock, dBlock)     bindEventWithProcess(target, @keyPathString(target, keyPath), notificationName, fBlock, cBlock, dBlock)


typedef BOOL (^WXDBFilterBlock)(id value);
typedef id _Nullable (^WXDBConvertBlock)(id value);
typedef void (^WXDBDidChangeBlock)(id value);

typedef WXDBObserver *_Nonnull(^WXDBOberverBlock)(id target, NSString *keyPath);
typedef WXDBObserver *_Nonnull(^WXDBOberverProcessBlock)(id target, NSString *keyPath, WXDBFilterBlock _Nullable fBlock, WXDBConvertBlock _Nullable cBlock, WXDBDidChangeBlock _Nullable dBlock);

typedef WXDBObserver *_Nonnull(^WXDBOberverEventBlock)(id target, NSString *keyPath, UIControlEvents event);
typedef WXDBObserver *_Nonnull(^WXDBOberverEventProcessBlock)(id target, NSString *keyPath, UIControlEvents event, WXDBFilterBlock _Nullable fBlock, WXDBConvertBlock _Nullable cBlock, WXDBDidChangeBlock _Nullable dBlock);

typedef WXDBObserver *_Nonnull(^WXDBOberverNotifyBlock)(id target, NSString *keyPath, NSNotificationName notificationName);
typedef WXDBObserver *_Nonnull(^WXDBOberverNotifyProcessBlock)(id target, NSString *keyPath, NSNotificationName notificationName, WXDBFilterBlock _Nullable fBlock, WXDBConvertBlock _Nullable cBlock, WXDBDidChangeBlock _Nullable dBlock);


@interface WXDBObserver : NSObject

+ (void)UseKVOBind; //kvo开关

// 初始化绑定
+ (WXDBOberverBlock)bind;
+ (WXDBOberverProcessBlock)bindWithProcess;

+ (void)removeDataBindForTarget:(id)target key:(NSString *)keyPath;
+ (void)removeAllDataBindsForTarget:(id)target;

- (WXDBOberverBlock)bind;
- (WXDBOberverProcessBlock)bindWithProcess;

- (WXDBOberverEventBlock)bindEvent;
- (WXDBOberverEventProcessBlock)bindEventWithProcess;
- (WXDBOberverNotifyBlock)bindNotify;
- (WXDBOberverNotifyProcessBlock)bindNotifyWithProcess;


- (WXDBOberverBlock)db_bind;
- (WXDBOberverProcessBlock)db_bindWithProcess;
- (WXDBOberverEventBlock)db_bindEvent;
- (WXDBOberverEventProcessBlock)db_bindEventWithProcess;
- (WXDBOberverNotifyBlock)db_bindNotify;
- (WXDBOberverNotifyProcessBlock)db_bindNotifyWithProcess;

@end

NS_ASSUME_NONNULL_END
