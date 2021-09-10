//
//  Dep.m
//  mvvmTest
//
//  Created by zk on 2021/9/3.
//

#import "Dep.h"
#import "Watcher.h"

@interface Dep ()
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, strong) NSMutableArray *watchers;

@end

@implementation Dep

- (instancetype)initWihtTarget:(id)target keyPath:(NSString *)keyPath {
    if (self = [super init]) {
        self.target = target;
        self.keyPath = keyPath;
        self.watchers = [NSMutableArray new];
    }
    return self;
}

- (void)addWatcher:(id)watcher {
    [self.watchers addObject:watcher];
}

- (void)notify {
    for (Watcher *watcher in self.watchers) {
        [watcher update];
    }
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:Dep.class]) {
        Dep *dep = (Dep *)object;
        if (dep.target == self.target && [dep.keyPath isEqualToString:self.keyPath]) {
            return YES;
        }
    }
    return NO;
}


@end
