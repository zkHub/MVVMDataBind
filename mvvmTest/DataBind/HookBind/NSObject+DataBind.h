//
//  NSObject+DataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import "DBTargetFlag.h"
#import "VueWatcher.h"
#import "DataBind.h"
#import "VueObserver.h"


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (DataBind)
@property(nonatomic, assign) BOOL db_isDidChanged;

- (VueWatcher *)addBindObserverWithKeyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock;

- (BOOL)addDep:(VueWatcher *)dep key:(NSString *)key;
- (void)removeDep:(VueWatcher *)dep;
- (VueWatcher *)depForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
