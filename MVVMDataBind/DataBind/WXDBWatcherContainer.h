//
//  WXDBWatcherContainer.h
//  MVVMDataBind
//
//  Created by zk on 2021/9/16.
//

#import <Foundation/Foundation.h>

@class WXDBWatcher;

NS_ASSUME_NONNULL_BEGIN

@interface WXDBWatcherContainer : NSObject

- (BOOL)containsWatcher:(WXDBWatcher *)watcher;
- (void)setWathcer:(WXDBWatcher *)watcher forKey:(NSString *)key;
- (WXDBWatcher *)watcherForKey:(NSString *)key;
- (void)removeWatcherForKey:(NSString *)key;
- (void)removeAllWathers;

@end

NS_ASSUME_NONNULL_END
