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

- (WXDBWatcher *)db_addBindObserver:(WXDBObserver *)observer keyPath:(NSString *)keyPath controlEvents:(UIControlEvents)controlEvents filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock;

@end

NS_ASSUME_NONNULL_END
