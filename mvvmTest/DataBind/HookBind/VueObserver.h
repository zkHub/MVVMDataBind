//
//  VueObserver.h
//  mvvmTest
//
//  Created by zk on 2021/9/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VueObserver;



NS_ASSUME_NONNULL_BEGIN

typedef id _Nullable (^VueDBAnyBlock)(id value);
typedef VueObserver *_Nonnull(^VueDBOberverBlock)(id target, NSString *keyPath);
typedef VueObserver *_Nonnull(^VueDBOberverUIBlock)(id target, NSString *keyPath, UIControlEvents event);
typedef VueObserver *_Nonnull(^VueDBOberverConvertBlock)(id target, NSString *property, VueDBAnyBlock block);
typedef VueObserver *_Nonnull(^VueDBOberverUIConvertBlock)(id target, NSString *property, UIControlEvents controlEvent, VueDBAnyBlock block);


@interface VueObserver : NSObject





+ (VueDBOberverBlock)bind;
+ (VueDBOberverUIBlock)bindUI;
+ (VueDBOberverConvertBlock)bindConvert;
+ (VueDBOberverUIConvertBlock)bindUIConvert;

- (VueDBOberverBlock)bind;
- (VueDBOberverUIBlock)bindUI;
- (VueDBOberverConvertBlock)bindConvert;
- (VueDBOberverUIConvertBlock)bindUIConvert;



- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock;
- (void)bindWithTarget:(UIControl *)target keyPath:(NSString *)keyPath controlEvent:(UIControlEvents)controlEvent convertBlock:(VueDBAnyBlock)convertBlock;

@end

NS_ASSUME_NONNULL_END
