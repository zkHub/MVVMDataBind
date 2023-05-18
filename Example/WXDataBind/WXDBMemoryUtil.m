//
//  WXDBMemoryUtil.m
//  WXDataBind_Example
//
//  Created by zk on 2021/11/25.
//  Copyright © 2021 192938268@qq.com. All rights reserved.
//

#import "WXDBMemoryUtil.h"
#include <mach/mach.h>

@implementation WXDBMemoryUtil

+ (float)useMemoryForApp{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS)
    {
        int64_t memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        return (memoryUsageInByte/1024.0/1024.0);
    }
    else
    {
        return -1;
    }
}

//设备总的内存
+ (float)totalMemoryForDevice{
    return (NSInteger)([NSProcessInfo processInfo].physicalMemory/1024.0/1024.0);
}

@end
