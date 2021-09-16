//
//  WXDBTargetFlag.m
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import "WXDBTargetFlag.h"
#import "WXDBObserver.h"


@interface WXDBTargetFlag ()
@property (nonatomic, strong) WXDBObserver *observer;

@end


@implementation WXDBTargetFlag

- (instancetype)initWithObserver:(id)observer {
    if (self = [super init]) {
        self.observer = observer;
    }
    return self;
}

- (void)dealloc {
    if (self.observer) {
        
    }
}

@end
