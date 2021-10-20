//
//  WXDBObserverContainer.h
//  MVVMDataBind
//
//  Created by zk on 2021/10/20.
//

#import <Foundation/Foundation.h>

@class WXDBObserver;

NS_ASSUME_NONNULL_BEGIN

@interface WXDBObserverContainer : NSObject

- (BOOL)containsObserver:(WXDBObserver *)observer;
- (void)addObserver:(WXDBObserver *)observer;
- (void)removeObserver:(WXDBObserver *)observer;

@end

NS_ASSUME_NONNULL_END
