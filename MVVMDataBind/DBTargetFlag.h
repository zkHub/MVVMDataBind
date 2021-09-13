//
//  DBTargetFlag.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBTargetFlag : NSObject
@property(nonatomic, copy) NSString *targetHash;

- (instancetype)initWithTargetHash:(NSString *)targetHash;
@end

NS_ASSUME_NONNULL_END
