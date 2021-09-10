//
//  DBWatcher.m
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import "DBWatcher.h"

@interface DBWatcher ()
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, weak) id observer;

@end

@implementation DBWatcher

- (instancetype)initWihtTarget:(id)target keyPath:(NSString *)keyPath observer:(id)observer {
    if (self = [super init]) {
        self.target = target;
        self.keyPath = keyPath;
        self.observer = observer;
    }
    return self;
}

- (void)dealloc {
    if (self.target && self.keyPath && self.observer) {
        [self.target removeObserver:self.observer forKeyPath:self.keyPath];
    }
}


@end
