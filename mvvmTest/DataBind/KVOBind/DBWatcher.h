//
//  DBWatcher.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBWatcher : NSObject
@property (nonatomic, weak, readonly) id target;
@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, weak, readonly) id observer;

- (instancetype)initWihtTarget:(id)target keyPath:(NSString *)keyPath observer:(id)observer;
@end

NS_ASSUME_NONNULL_END
