//
//  WXDataBindContainer.m
//  WXDataBind
//
//  Created by zk on 2021/12/8.
//

#import "WXDataBindContainer.h"

@interface WXDataBindContainer ()
@property (nonatomic, strong) NSMutableDictionary *objectContainer;

@end

@implementation WXDataBindContainer

- (instancetype)init {
    if (self = [super init]) {
        self.objectContainer = [NSMutableDictionary new];
    }
    return self;
}

- (BOOL)containsObject:(id)object {
    return [self.objectContainer.allValues containsObject:object];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (object && key) {
        [self.objectContainer setObject:object forKey:key];
    }
}

- (id)objectForKey:(NSString *)key {
    return [self.objectContainer objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.objectContainer removeObjectForKey:key];
}

- (void)removeAllObjects {
    [self.objectContainer removeAllObjects];
}

- (void)dealloc {
    [self removeAllObjects];
}

@end
