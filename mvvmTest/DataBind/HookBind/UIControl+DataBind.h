//
//  UIControl+DataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/8.
//

#import <UIKit/UIKit.h>
#import "NSObject+DataBind.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (DataBind)

@property(nonatomic, copy) NSString *db_ctrl_bindKeyPath;


- (VueWatcher *)addBindUIObserverWithKeyPath:(NSString *)keyPath forControlEvents:(UIControlEvents)controlEvent convertBlock:(VueDBAnyBlock)convertBlock;

@end

NS_ASSUME_NONNULL_END
