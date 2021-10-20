//
//  WXDBWatcherContainer.m
//  MVVMDataBind
//
//  Created by zk on 2021/9/16.
//

#import "WXDBWatcherContainer.h"
#import "WXDBWatcher.h"

@interface WXDBWatcherContainer ()
@property (nonatomic, strong) NSMutableDictionary *wathcerMaps;

@end


@implementation WXDBWatcherContainer

- (instancetype)init {
    if (self = [super init]) {
        self.wathcerMaps = [NSMutableDictionary new];
    }
    return self;
}

- (BOOL)containsWatcher:(WXDBWatcher *)watcher {
    return [self.wathcerMaps.allValues containsObject:watcher];
}

- (void)setWathcer:(WXDBWatcher *)watcher forKey:(NSString *)key {
    if (watcher && key) {
        [self.wathcerMaps setObject:watcher forKey:key];
    }
}

- (WXDBWatcher *)watcherForKey:(NSString *)key {
    if (key) {
        return [self.wathcerMaps objectForKey:key];
    }
    return nil;
}

- (void)removeWatcherForKey:(NSString *)key {
    if (key) {
        [self.wathcerMaps removeObjectForKey:key];
    }
}

- (void)removeAllWathers {
    for (NSString *key in self.wathcerMaps.allKeys) {
        WXDBWatcher *watcher = [self.wathcerMaps objectForKey:key];
        if ([watcher.observer respondsToSelector:@selector(removeWathcer:)]) {
            [watcher.observer removeWathcer:watcher];
        }
    }
    [self.wathcerMaps removeAllObjects];
}


- (void)dealloc {
    [self removeAllWathers];
}


@end
