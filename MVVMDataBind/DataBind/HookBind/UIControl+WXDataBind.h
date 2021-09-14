//
//  UIControl+WXDataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/8.
//

#import <UIKit/UIKit.h>
#import "NSObject+WXDataBind.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (WXDataBind)

@property(nonatomic, copy) NSString *db_ctrl_bindKeyPath;


- (WXDBWatcher *)addBindUIObserverWithKeyPath:(NSString *)keyPath forControlEvents:(UIControlEvents)controlEvent convertBlock:(VueDBAnyBlock)convertBlock;

@end

NS_ASSUME_NONNULL_END
