//
//  VueWatcher.m
//  VueIOS
//
//  Created by guoyuze on 2021/9/2.
//

#import "VueWatcher.h"
#import "YYModel.h"
#import <objc/runtime.h>
#import "NSObject+DataBind.h"

@interface VueWatcher ()
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) VueDBAnyBlock convertBlock;

@end
@implementation VueWatcher


- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath convertBlock:(VueDBAnyBlock)convertBlock {
    if(self = [super init]){
        self.target = target;
        self.keyPath = keyPath;
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
    [self.observer updateValue:vaule dep:self];
}

- (void)updateValue:(id)vaule {
    if (!vaule) {
        return;
    }
    id tempValue = vaule;
    id oldVaule = [self.target valueForKey:self.keyPath];
    if ([tempValue isEqual:oldVaule]) {
        return;
    }
    self.db_isDidChanged = YES;

    objc_property_t property = class_getProperty([self.target class], self.keyPath.UTF8String);
    const char *property_attr = property_copyAttributeValue(property, "T");
    YYEncodingType targetPropertyType = YYEncodingGetType(property_attr);
    switch (targetPropertyType) {
        case YYEncodingTypeObject: {
            NSString *attr = [NSString stringWithUTF8String:property_attr];
            if ([attr containsString:@"NSString"]) {
                if ([vaule isKindOfClass:NSNumber.class] || [vaule isKindOfClass:NSString.class]) {
                    tempValue = [NSString stringWithFormat:@"%@", vaule];
                }
            } else if ([attr containsString:@"NSNumber"]) {
                if ([vaule isKindOfClass:NSNumber.class]) {
                    tempValue = vaule;
                } else if ([vaule isKindOfClass:NSString.class]) {
                    NSString *valueStr = (NSString *)vaule;
                    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
                    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                    tempValue = [numFormatter numberFromString:valueStr];
                }
            } else {
                return;
            }
        } break;
        case YYEncodingTypeInt64: {
            if ([vaule isKindOfClass:NSString.class]) {
                tempValue = [NSNumber numberWithLongLong:[vaule longLongValue]];
            } else if ([vaule isKindOfClass:NSNumber.class]) {
                tempValue = vaule;
            }
        } break;
        case YYEncodingTypeFloat: {
            if ([vaule isKindOfClass:NSString.class]) {
                tempValue = [NSNumber numberWithFloat:[vaule floatValue]];
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
