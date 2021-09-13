//
//  ObserverViewModel.m
//  mvvmTest
//
//  Created by zk on 2021/9/3.
//

#import "ObserverViewModel.h"
#import "DBObserver.h"
#import "Dep.h"
#import "Watcher.h"


@interface ObserverViewModel ()
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSMutableArray *bindKeys;
@property (nonatomic, strong) NSMutableDictionary *bindMaps;

@end


@implementation ObserverViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.bindKeys = [NSMutableArray new];
        self.bindMaps = [NSMutableDictionary new];
    }
    return self;
}

- (void)bindKey:(NSString *)key toTarget:(id)target targetKey:(NSString *)targetKey {
    if ([self.bindMaps.allKeys containsObject:targetKey]) {
        return;
    }
    [target addObserver:self forKeyPath:targetKey options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    self.target = target;
    [self.bindMaps setObject:key forKey:targetKey];
}

- (NSString *)mapCodeWithKey:(NSString *)key toTarget:(id)target targetKey:(NSString *)targetKey {
    return [NSString stringWithFormat:@"%@_%@_%@", key, @([target hash]), targetKey];
}


- (void)twoWayBindKey:(NSString *)key toTarget:(id)target targetKey:(NSString *)targetKey {
    NSString *mapCode = [self mapCodeWithKey:key toTarget:target targetKey:targetKey];
    if ([self.bindMaps.allKeys containsObject:mapCode]) {
        return;
    }
    Dep *dep = [[Dep alloc] initWihtTarget:target keyPath:targetKey];
    [self.bindMaps setObject:dep forKey:mapCode];
    
    [target addObserver:self forKeyPath:targetKey options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    [self addObserver:self forKeyPath:key options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if (object == self) {
        for (NSString *targetKey in self.bindMaps.allKeys) {
            NSString *key = [self.bindMaps objectForKey:targetKey];
            if ([key isEqualToString:keyPath]) {
                id value = [self.target valueForKey:targetKey];
                if (![value isEqual:newValue]) {
                    [self.target setValue:newValue forKey:targetKey];
                }
            }
        }
    } else if (object == self.target) {
        NSString *key = [self.bindMaps objectForKey:keyPath];
        if (key) {
            id value = [self valueForKey:key];
            if (![value isEqual:newValue]) {
                [self setValue:newValue forKey:key];
            }
        }
    }

}



- (void)dealloc {
    for (NSString *targetKey in self.bindMaps.allKeys) {
        [self.target removeObserver:self forKeyPath:targetKey];
    }
    for (NSString *key in self.bindMaps.allValues) {
        [self removeObserver:self forKeyPath:key];
    }
}


@end
