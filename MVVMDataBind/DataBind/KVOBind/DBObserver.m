//
//  DBObserver.m
//  mvvmTest
//
//  Created by zk on 2021/9/2.
//

#import "DBObserver.h"
#import "DBWatcher.h"
@interface DBObserver ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, DBWatcher *> *watcherMaps;

@end


@implementation DBObserver

- (instancetype)init {
    if (self = [super init]) {
        self.watcherMaps = [NSMutableDictionary new];
    }
    return self;
}


- (NSString *)depKeyWithTarget:(id)target keyPath:(NSString *)keyPath {
    return [NSString stringWithFormat:@"%@_%@", @([target hash]), keyPath];
}

- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath {
    NSString *depKey = [self depKeyWithTarget:target keyPath:keyPath];
    if ([self.watcherMaps.allKeys containsObject:depKey]) {
        [self.watcherMaps removeObjectForKey:depKey];
    }
    [target addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew) context:nil];
    DBWatcher *watcher = [[DBWatcher alloc] initWihtTarget:target keyPath:keyPath observer:self];
    [self.watcherMaps setObject:watcher forKey:depKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    NSString *depKey = [self depKeyWithTarget:object keyPath:keyPath];
    if ([self.watcherMaps.allKeys containsObject:depKey]) {
        for (DBWatcher *watcher in self.watcherMaps.allValues) {
            BOOL isCurrent = watcher.target == object && [watcher.keyPath isEqualToString:keyPath];
            if (isCurrent) {
                continue;
            }
            BOOL isEqualValue = [[watcher.target valueForKey:watcher.keyPath] isEqual:newValue];
            if (isEqualValue) {
                continue;
            }
            [watcher.target setValue:newValue forKey:watcher.keyPath];
        }
    }
}

- (void)dealloc {
    if (_watcherMaps) {
        [_watcherMaps removeAllObjects];
    }
}


@end
