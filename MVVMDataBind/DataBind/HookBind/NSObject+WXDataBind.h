//
//  NSObject+WXDataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import "WXDBTargetFlag.h"
#import "WXDBWatcher.h"


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WXDataBind)
@property(nonatomic, assign) BOOL db_isDidChanged;
//@property (nonatomic, strong) WXDBTargetFlag *db_targetFlag;

- (WXDBWatcher *)addBindObserverWithKeyPath:(NSString *)keyPath convertBlock:(WXDBAnyBlock)convertBlock;


- (NSString *)watcherKeyWithKeyPath:(NSString *)keyPath;
- (void)setWatcher:(WXDBWatcher *)watcher forKey:(NSString *)key;
- (WXDBWatcher *)watcherForKey:(NSString *)key;
- (void)removeWatcherForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
