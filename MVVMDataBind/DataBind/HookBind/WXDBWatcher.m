//
//  WXDBWatcher.m
//  VueIOS
//
//  Created by guoyuze on 2021/9/2.
//

#import "WXDBWatcher.h"
#import <objc/runtime.h>
#import "NSObject+WXDataBind.h"
#import "WXDataBindTools.h"
#import "WXDBTargetFlag.h"


@interface WXDBWatcher ()
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) WXDBAnyBlock convertBlock;
@property (nonatomic, copy) NSString *watcherKey;

@property (nonatomic, strong) WXDBTargetFlag *db_targetFlag;

@end



@implementation WXDBWatcher


- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(WXDBAnyBlock)convertBlock {
    if(self = [super init]){
        self.target = target;
        self.keyPath = keyPath;
        self.watcherKey = [target watcherKeyWithKeyPath:keyPath];
        self.convertBlock = convertBlock;
    }
    return self;
}


- (void)notify {
    if (self.db_isDidChanged) {
        self.db_isDidChanged = NO;
        return;
    }
    id vaule = [self.target valueForKey:self.keyPath];
    [self.observer updateValue:vaule watcher:self];
}

- (void)updateValue:(id)vaule {
    if (!vaule) {
        return;
    }
    id oldVaule = [self.target valueForKey:self.keyPath];
    if ([vaule isEqual:oldVaule]) {
        return;
    }
    self.db_isDidChanged = YES;
    
    id tempValue = nil;
    objc_property_t property = class_getProperty([self.target class], self.keyPath.UTF8String);
    const char *property_attr = property_copyAttributeValue(property, "T");
    WXDBEncodingType targetPropertyType = WXDBEncodingGetType(property_attr);
    switch (targetPropertyType) {
        case WXDBEncodingTypeObject: {
            NSString *attr = [NSString stringWithUTF8String:property_attr];
            if ([attr containsString:@"NSString"]) {
                if ([vaule isKindOfClass:NSString.class]) {
                    tempValue = [NSString stringWithFormat:@"%@", vaule];
                } else if ([vaule isKindOfClass:NSNumber.class]) {
                    tempValue = [NSString stringWithFormat:@"%@", [vaule stringValue]];
                }
            } else if ([attr containsString:@"NSNumber"]) {
                if ([vaule isKindOfClass:NSNumber.class]) {
                    tempValue = vaule;
                } else if ([vaule isKindOfClass:NSString.class]) {
                    tempValue = WXDBNSNumberCreateFromID(vaule);
                }
            }
        } break;
        case WXDBEncodingTypeBool:
        case WXDBEncodingTypeInt8:
        case WXDBEncodingTypeUInt8:
        case WXDBEncodingTypeInt16:
        case WXDBEncodingTypeUInt16:
        case WXDBEncodingTypeInt32:
        case WXDBEncodingTypeUInt32:
        case WXDBEncodingTypeInt64:
        case WXDBEncodingTypeUInt64:
        case WXDBEncodingTypeFloat:
        case WXDBEncodingTypeDouble:{
            if ([vaule isKindOfClass:NSString.class]) {
                tempValue = WXDBNSNumberCreateFromID(vaule);
            } else if ([vaule isKindOfClass:NSNumber.class]) {
                tempValue = vaule;
            }
        } break;
        default:
            break;
    }
    
    if (self.convertBlock) {
        tempValue = self.convertBlock(tempValue);
    }
    
    if ([tempValue isEqual:oldVaule]) {
        return;
    }
    [self.target setValue:tempValue forKey:self.keyPath];
    NSLog(@"watcher--%@ setValue:%@ forKey:%@", [self.target class], tempValue, self.keyPath);
}

@end
