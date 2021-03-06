//
//  UIControl+WXDataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/8.
//

#import <UIKit/UIKit.h>
#import "NSObject+WXDataBind.h"

@class WXDBObserver;

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (WXDataBind)

- (WXDBWatcher *)db_addBindUIObserver:(WXDBObserver *)observer keyPath:(NSString *)keyPath forControlEvents:(UIControlEvents)controlEvent convertBlock:(WXDBAnyBlock)convertBlock;

@end

NS_ASSUME_NONNULL_END
