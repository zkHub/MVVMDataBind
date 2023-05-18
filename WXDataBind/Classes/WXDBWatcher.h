//
//  WXDBWatcher.h
//  VueIOS
//
//  Created by zk on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import "WXDBObserver.h"

@class WXDBWatcher;

NS_ASSUME_NONNULL_BEGIN

@protocol WXDBWatcherDelegate <NSObject>

- (void)updateValue:(id)value watcher:(WXDBWatcher*)watcher;

@end


@interface WXDBWatcher : NSObject
@property (nonatomic, weak, readonly) id target;
@property (nonatomic, copy, readonly) NSString *watcherKey;
@property (nonatomic, weak) id<WXDBWatcherDelegate> observer;

- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock;
- (void)notify;
- (void)updateValue:(id)vaule;

@end

NS_ASSUME_NONNULL_END
