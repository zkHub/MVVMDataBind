//
//  WXDBWatcher.m
//  VueIOS
//
//  Created by zk on 2021/9/2.
//

#import "WXDBWatcher.h"
#import <objc/runtime.h>
#import "NSObject+WXDataBind.h"
#import "WXDataBindTools.h"


@interface WXDBWatcher ()
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) WXDBFilterBlock filterBlock;
@property (nonatomic, copy) WXDBConvertBlock convertBlock;
@property (nonatomic, copy) WXDBDidChangeBlock didChangeBlock;
@property (nonatomic, copy) NSString *watcherKey;
@property (nonatomic, assign) BOOL db_isDidChanged;

@end



@implementation WXDBWatcher


- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath filterBlock:(WXDBFilterBlock)filterBlock convertBlock:(WXDBConvertBlock)convertBlock didChangeBlock:(WXDBDidChangeBlock)didChangeBlock {
    if(self = [super init]){
        self.target = target;
        self.keyPath = keyPath;
        self.watcherKey = [target db_watcherKeyWithKeyPath:keyPath];
        self.filterBlock = filterBlock;
        self.convertBlock = convertBlock;
        self.didChangeBlock = didChangeBlock;
    }
    return self;
}

- (void)notify {
    if (self.db_isDidChanged) {
        self.db_isDidChanged = NO;
        return;
    }
    id vaule = [self.target valueForKey:self.keyPath];
    if (self.didChangeBlock) {
        self.didChangeBlock(vaule);
    }
    [self.observer updateValue:vaule watcher:self];
}

- (void)updateValue:(id)vaule {
    self.db_isDidChanged = YES;
    id tempValue = nil;
    objc_property_t property = class_getProperty([self.target class], self.keyPath.UTF8String);
    const char *property_attr = property_copyAttributeValue(property, "T");
    WXDBEncodingType targetPropertyType = WXDBEncodingGetType(property_attr);
    switch (targetPropertyType) {
        case WXDBEncodingTypeObject: {
            NSString *attr = [NSString stringWithUTF8String:property_attr];
            NSArray *attrArray = [attr componentsSeparatedByString:@"\""];
            NSString *classString = [attrArray objectAtIndex:1];
            if (classString.length == 0) {
                break;
            }
            Class aClass = NSClassFromString(classString);
            if (!aClass) {
                break;
            }
            if ([vaule isKindOfClass:aClass]) {
                tempValue = vaule;
            } else {
                if ([attr containsString:@"NSString"]) {
                    if ([vaule isKindOfClass:NSNumber.class]) {
                        tempValue = [NSString stringWithFormat:@"%@", [vaule stringValue]];
                    }
                } else if ([attr containsString:@"NSNumber"]) {
                    if ([vaule isKindOfClass:NSString.class]) {
                        tempValue = WXDBNSNumberCreateFromID(vaule);
                    }
                } else {
                    break;
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
            if ([vaule isKindOfClass:NSNumber.class]) {
                tempValue = vaule;
            } else if ([vaule isKindOfClass:NSString.class]) {
                tempValue = WXDBNSNumberCreateFromID(vaule);
            } else {
                break;
            }
        } break;
        default:
            break;
    }
    
    BOOL needUpdate = YES;
    if (self.filterBlock) {
        needUpdate = self.filterBlock(tempValue);
    }
    if (needUpdate) {
        if (self.convertBlock) {
            tempValue = self.convertBlock(tempValue);
        }
        [self.target setValue:tempValue forKey:self.keyPath];
        if (self.didChangeBlock) {
            self.didChangeBlock(tempValue);
        }
    } else {
        self.db_isDidChanged = NO;
    }
//    NSLog(@"watcher--isUpdate(%@) %@ setValue:%@ forKey:%@", @(needUpdate), [self.target class], tempValue, self.keyPath);

}

@end
