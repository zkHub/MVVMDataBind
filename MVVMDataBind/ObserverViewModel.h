//
//  ObserverViewModel.h
//  mvvmTest
//
//  Created by zk on 2021/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObserverViewModel : NSObject
@property (nonatomic, copy) NSString *title;


- (void)bindKey:(NSString *)key toTarget:(id)target targetKey:(NSString *)targetKey;
- (void)twoWayBindKey:(NSString *)key toTarget:(id)target targetKey:(NSString *)targetKey;

@end

NS_ASSUME_NONNULL_END
