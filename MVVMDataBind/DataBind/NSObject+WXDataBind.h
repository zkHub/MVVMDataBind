//
//  NSObject+WXDataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import "WXDBWatcher.h"


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WXDataBind)
@property(nonatomic, assign) BOOL db_isDidChanged;

- (WXDBWatcher *)db_addBindObserverWithKeyPath:(NSString *)keyPath convertBlock:(WXDBAnyBlock)convertBlock;


- (NSString *)db_watcherKeyWithKeyPath:(NSString *)keyPath;
- (void)db_setWatcher:(WXDBWatcher *)watcher forKey:(NSString *)key;
- (WXDBWatcher *)db_watcherForKey:(NSString *)key;
- (void)db_removeWatcherForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
