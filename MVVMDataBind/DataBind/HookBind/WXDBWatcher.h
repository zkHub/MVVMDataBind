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

@protocol VupDepDelegate <NSObject>

- (void)updateValue:(id)value watcher:(WXDBWatcher*)watcher;

@end


@interface WXDBWatcher : NSObject
@property (nonatomic, weak) id<VupDepDelegate> observer;
@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock;
- (void)notify;
- (void)updateValue:(id)vaule;

@end

NS_ASSUME_NONNULL_END
