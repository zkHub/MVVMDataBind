//
//  WXDBMemoryUtil.h
//  WXDataBind_Example
//
//  Created by zk on 2021/11/25.
//  Copyright © 2021 192938268@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXDBMemoryUtil : NSObject

//当前app内存使用量
+ (float)useMemoryForApp;

//设备总的内存
+ (float)totalMemoryForDevice;

@end

NS_ASSUME_NONNULL_END
