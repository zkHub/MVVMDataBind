//
//  DBTargetFlag.m
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import "DBTargetFlag.h"
#import "ObserverManager.h"


@implementation DBTargetFlag

- (instancetype)initWithTargetHash:(NSString *)targetHash {
    if (self = [super init]) {
        self.targetHash = targetHash;
    }
    return self;
}

- (void)dealloc {
    [[ObserverManager sharedInstance] unbindWithTargetHash:self.targetHash];
}

@end
