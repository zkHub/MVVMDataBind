//
//  VueWatcher.h
//  VueIOS
//
//  Created by guoyuze on 2021/9/2.
//

#import <Foundation/Foundation.h>
#import "VueObserver.h"

@class VueWatcher;

NS_ASSUME_NONNULL_BEGIN

@protocol VupDepDelegate <NSObject>

- (void)updateValue:(id)value dep:(VueWatcher*)dep;

@end


@interface VueWatcher : NSObject
@property (nonatomic, weak) id<VupDepDelegate> observer;

- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock;
- (void)notify;
- (void)updateValue:(id)vaule;

@end

NS_ASSUME_NONNULL_END
