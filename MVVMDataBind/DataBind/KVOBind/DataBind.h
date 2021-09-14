//
//  WXDataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DataBind;

NS_ASSUME_NONNULL_BEGIN
typedef DataBind *_Nonnull(^DataBindBlock)(id target, NSString *keyPath);
typedef DataBind *_Nonnull(^DataBindUIBlock)(id target, NSString *keyPath, UIControlEvents event);

@interface DataBind : NSObject

+ (DataBindBlock)bind;
+ (DataBindUIBlock)bindUI;

- (DataBindBlock)bind;
- (DataBindUIBlock)bindUI;

- (void)dependOn:(id)depender;

@end

NS_ASSUME_NONNULL_END
