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

#define keypathSting(target, keyPath) \
    (((void)(NO && ((void)target.keyPath, NO)), # keyPath))


#define WXDBBind(target, keyPath)                           WXDBObserver.bind(target, @keypathSting(target, keyPath))
#define dbBind(target, keyPath)                             bind(target, @keypathSting(target, keyPath))
#define dbBindUI(target, keyPath, event)                    bindUI(target, @keypathSting(target, keyPath), event)
#define dbBindConvert(target, keyPath, block)               bindConvert(target, @keypathSting(target, keyPath), block)
#define dbBindUIConvert(target, keyPath, event, block)      bindUIConvert(target, @keypathSting(target, keyPath), event, block)


typedef id _Nullable (^WXDBAnyBlock)(id value);
typedef WXDBObserver *_Nonnull(^WXDBOberverBlock)(id target, NSString *keyPath);
typedef WXDBObserver *_Nonnull(^WXDBOberverUIBlock)(id target, NSString *keyPath, UIControlEvents event);
typedef WXDBObserver *_Nonnull(^WXDBOberverConvertBlock)(id target, NSString *property, WXDBAnyBlock block);
typedef WXDBObserver *_Nonnull(^WXDBOberverUIConvertBlock)(id target, NSString *property, UIControlEvents event, WXDBAnyBlock block);



@interface WXDBObserver : NSObject

+ (WXDBOberverBlock)bind;
+ (WXDBOberverUIBlock)bindUI;
+ (WXDBOberverConvertBlock)bindConvert;
+ (WXDBOberverUIConvertBlock)bindUIConvert;

- (WXDBOberverBlock)bind;
- (WXDBOberverUIBlock)bindUI;
- (WXDBOberverConvertBlock)bindConvert;
- (WXDBOberverUIConvertBlock)bindUIConvert;


- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(WXDBAnyBlock _Nullable)convertBlock;
- (void)bindWithTarget:(UIControl *)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)controlEvent convertBlock:(WXDBAnyBlock _Nullable)convertBlock;

@end

NS_ASSUME_NONNULL_END
