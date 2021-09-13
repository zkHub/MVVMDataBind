//
//  Watcher.h
//  mvvmTest
//
//  Created by zk on 2021/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Watcher : NSObject

- (instancetype)initWithTarget:(id)target targetKey:(NSString *)targetKey observer:(id)observer keyPath:(NSString *)keyPath;
- (void)update;

@end

NS_ASSUME_NONNULL_END
