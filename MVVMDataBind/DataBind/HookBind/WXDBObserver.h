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

typedef id _Nullable (^VueDBAnyBlock)(id value);
typedef WXDBObserver *_Nonnull(^VueDBOberverBlock)(id target, NSString *keyPath);
typedef WXDBObserver *_Nonnull(^VueDBOberverUIBlock)(id target, NSString *keyPath, UIControlEvents event);
typedef WXDBObserver *_Nonnull(^VueDBOberverConvertBlock)(id target, NSString *property, VueDBAnyBlock block);
typedef WXDBObserver *_Nonnull(^VueDBOberverUIConvertBlock)(id target, NSString *property, UIControlEvents controlEvent, VueDBAnyBlock block);


@interface WXDBObserver : NSObject

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
