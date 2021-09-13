//
//  DBObserver.h
//  mvvmTest
//
//  Created by zk on 2021/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBObserver : NSObject

- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath;


@end

NS_ASSUME_NONNULL_END
