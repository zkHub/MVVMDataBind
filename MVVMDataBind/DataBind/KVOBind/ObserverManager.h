//
//  ObserverManager.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObserverManager : NSObject

+ (instancetype)sharedInstance;

- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath chainCode:(NSString *)chainCode;

- (NSString *)getChainCodeWithTarget:(id)target;

- (void)unbindWithTargetHash:(NSString *)targetHash;

@end

NS_ASSUME_NONNULL_END
