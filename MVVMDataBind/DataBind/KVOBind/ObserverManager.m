//
//  ObserverManager.m
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import "ObserverManager.h"
#import "DBObserver.h"


@interface ObserverManager ()
@property(nonatomic, strong) NSMutableDictionary<NSString *, DBObserver *> *observerForChainCodeMap;

@end


@implementation ObserverManager

//MARK: - init
+ (instancetype)sharedInstance {
    static ObserverManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.observerForChainCodeMap = [NSMutableDictionary new];
    }
    return self;
}

//MARK: - bind Observer
- (void)bindWithTarget:(id)target keyPath:(NSString *)keyPath chainCode:(NSString *)chainCode {
    DBObserver *observer = [self getObserverWithChainCode:chainCode];
    [observer bindWithTarget:target keyPath:keyPath];
}

- (NSString *)getChainCodeWithTarget:(id)target {
    return [NSString stringWithFormat:@"%@_%@", @([target hash]), @([[NSDate date] timeIntervalSince1970])];
}

- (DBObserver *)getObserverWithChainCode:(NSString *)chainCode {
    DBObserver *observer = [self.observerForChainCodeMap objectForKey:chainCode];
    if (!observer) {
        observer = [DBObserver new];
        [self.observerForChainCodeMap setObject:observer forKey:chainCode];
    }
    return observer;
}

//MARK: - unbind
- (void)unbindWithTargetHash:(NSString *)targetHash {

}


@end
