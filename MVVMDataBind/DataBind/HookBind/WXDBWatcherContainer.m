//
//  WXDBWatcherContainer.m
//  MVVMDataBind
//
//  Created by zk on 2021/9/16.
//

#import "WXDBWatcherContainer.h"
#import "WXDBWatcher.h"

@implementation WXDBWatcherContainer

- (instancetype)init {
    if (self = [super init]) {
        self.wathcerMaps = [NSMutableDictionary new];
    }
    return self;
}

- (void)dealloc {
    for (NSString *key in self.wathcerMaps.allKeys) {
        WXDBWatcher *watcher = [self.wathcerMaps objectForKey:key];
        if ([watcher.observer respondsToSelector:@selector(removeWathcer:)]) {
            [watcher.observer removeWathcer:watcher];
        }
    }
    [self.wathcerMaps removeAllObjects];
}


@end
