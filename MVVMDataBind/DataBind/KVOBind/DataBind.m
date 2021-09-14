//
//  WXDataBind.m
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import "DataBind.h"
#import "ObserverManager.h"


@interface DataBind ()
@property (nonatomic, copy) NSString *chainCode;

@end


@implementation DataBind

//MARK: - manager
+ (ObserverManager *)dbManager {
    return [ObserverManager sharedInstance];
}

- (ObserverManager *)dbManager {
    return [ObserverManager sharedInstance];
}

//MARK: - bind
+ (DataBindBlock)bind {
    return ^DataBind *(id target, NSString *keyPath) {
        NSString *chainCode = [self.dbManager getChainCodeWithTarget:target];
        [[self dbManager] bindWithTarget:target keyPath:keyPath chainCode:chainCode];
        DataBind *db = [DataBind new];
        db.chainCode = chainCode;
        return db;
    };
}

+ (DataBindUIBlock)bindUI {
    return ^DataBind *(id target, NSString *keyPath, UIControlEvents event) {
        NSString *chainCode = [self.dbManager getChainCodeWithTarget:target];
        [[self dbManager] bindWithTarget:target keyPath:keyPath chainCode:chainCode];
        DataBind *db = [DataBind new];
        db.chainCode = chainCode;
        return db;
    };
}

- (DataBindBlock)bind {
    return ^DataBind *(id target, NSString *keyPath) {
        [[self dbManager] bindWithTarget:target keyPath:keyPath chainCode:self.chainCode];
        return self;
    };
}

- (DataBindUIBlock)bindUI {
    return ^DataBind *(id target, NSString *keyPath, UIControlEvents event) {
        [[self dbManager] bindWithTarget:target keyPath:keyPath chainCode:self.chainCode];
        return self;
    };
}

- (void)dependOn:(id)depender {
    if (depender) {
        
    }
}

@end
