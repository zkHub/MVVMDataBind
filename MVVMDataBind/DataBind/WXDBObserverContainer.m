//
//  WXDBObserverContainer.m
//  MVVMDataBind
//
//  Created by zk on 2021/10/20.
//

#import "WXDBObserverContainer.h"
#import "WXDBObserver.h"

@interface WXDBObserverContainer ()
@property (nonatomic, strong) NSMutableArray<WXDBObserver *> *observers;

@end


@implementation WXDBObserverContainer

- (instancetype)init {
    if (self = [super init]) {
        self.observers = [NSMutableArray new];
    }
    return self;
}

- (BOOL)containsObserver:(WXDBObserver *)observer {
    return [self.observers containsObject:observer];
}

- (void)addObserver:(WXDBObserver *)observer {
    if (![observer isKindOfClass:WXDBObserver.class]) {
        return;
    }
    [self.observers addObject:observer];
}

- (void)removeObserver:(WXDBObserver *)observer {
    [self.observers removeObject:observer];
}

- (void)dealloc {
    [self.observers removeAllObjects];
}

@end
