//
//  Dep.h
//  mvvmTest
//
//  Created by zk on 2021/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dep : NSObject
@property (nonatomic, weak, readonly) id target;
@property (nonatomic, copy, readonly) NSString *keyPath;

- (instancetype)initWihtTarget:(id)target keyPath:(NSString *)keyPath;
- (void)addWatcher:(id)watcher;
- (void)notify;

@end

NS_ASSUME_NONNULL_END
