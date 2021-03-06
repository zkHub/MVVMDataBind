//
//  WXDBWatcher.h
//  VueIOS
//
//  Created by guoyuze on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import "WXDBObserver.h"

@class WXDBWatcher;

NS_ASSUME_NONNULL_BEGIN

@protocol WXDBWatcherDelegate <NSObject>

- (void)updateValue:(id)value watcher:(WXDBWatcher*)watcher;
- (void)removeWathcer:(WXDBWatcher *)watcher;

@end


@interface WXDBWatcher : NSObject
@property (nonatomic, weak) id<WXDBWatcherDelegate> observer;
@property (nonatomic, weak, readonly) id target;
@property (nonatomic, copy, readonly) NSString *watcherKey;

- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(WXDBAnyBlock)convertBlock;
- (void)notify;
- (void)updateValue:(id)vaule;

@end

NS_ASSUME_NONNULL_END
