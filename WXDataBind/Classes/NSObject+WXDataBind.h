//
//  NSObject+WXDataBind.h
//  mvvmTest
//
//  Created by zk on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import "WXDBWatcher.h"
#import "WXDataBindContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WXDataBind)
@property (nonatomic, strong) WXDataBindContainer *db_observerContainer;
@property (nonatomic, strong) WXDataBindContainer *db_watcherContainer;

- (WXDBWatcher *)db_addBindObserver:(WXDBObserver *)observer keyPath:(NSString *)keyPath filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock;

// 适用于 UITextView UITextField 有绑定系统通知的控件
- (WXDBWatcher *)db_addBindObserver:(WXDBObserver *)observer keyPath:(NSString *)keyPath notificationName:(NSNotificationName)notificationName filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock;

- (NSString *)db_watcherKeyWithKeyPath:(NSString *)keyPath;
- (NSString *)db_keyPathWithWatcherKey:(NSString *)watcherKey;

// observer
- (void)db_setObserver:(WXDBObserver *)observer forKey:(NSString *)key;
- (WXDBObserver *)db_observerForKey:(NSString *)key;

// watcher
- (void)db_setWatcher:(WXDBWatcher *)watcher forKey:(NSString *)key;
- (WXDBWatcher *)db_watcherForKey:(NSString *)key;

// 移除observer和wathcer
- (void)db_removeDataBindForKey:(NSString *)key;
- (void)db_removeAllDataBinds;


@end

NS_ASSUME_NONNULL_END
