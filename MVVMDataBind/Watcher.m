//
//  Watcher.m
//  mvvmTest
//
//  Created by zk on 2021/9/3.
//

#import "Watcher.h"

@interface Watcher ()
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *targetKey;
@property (nonatomic, weak) id observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, strong) id value;

@end

@implementation Watcher


- (instancetype)initWithTarget:(id)target targetKey:(NSString *)targetKey observer:(id)observer keyPath:(NSString *)keyPath {
    if (self = [super init]) {
        self.target = target;
        self.targetKey = targetKey;
        self.observer = observer;
        self.keyPath = keyPath;
        self.value = [observer valueForKey:keyPath];
    }
    return self;
}

- (void)update {
    if (self.target) {
        id value = [self.observer valueForKey:self.keyPath];
        if (![value isEqual:self.value]) {
            [self.target setValue:value forKey:self.targetKey];
        }
    }
}

@end
