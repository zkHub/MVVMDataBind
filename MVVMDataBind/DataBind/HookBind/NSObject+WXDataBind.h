//
//  NSObject+WXDataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import "DBTargetFlag.h"
#import "WXDBWatcher.h"
#import "WXDBObserver.h"







NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WXDataBind)
@property(nonatomic, assign) BOOL db_isDidChanged;

- (WXDBWatcher *)addBindObserverWithKeyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock;

- (BOOL)addDep:(WXDBWatcher *)dep key:(NSString *)key;
- (void)removeDep:(WXDBWatcher *)dep;
- (WXDBWatcher *)depForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
