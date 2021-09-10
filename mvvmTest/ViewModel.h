//
//  ViewModel.h
//  MVVM
//
//  Created by zk on 2021/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) float progress;

@end

NS_ASSUME_NONNULL_END
