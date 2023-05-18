//
//  WXDataBindTools.m
//  MVVMDataBind
//
//  Created by zk on 2021/9/15.
//

#import "WXDataBindTools.h"


WXDBEncodingType WXDBEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return WXDBEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return WXDBEncodingTypeUnknown;
    
    WXDBEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= WXDBEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= WXDBEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= WXDBEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= WXDBEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= WXDBEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= WXDBEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= WXDBEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }

    len = strlen(type);
    if (len == 0) return WXDBEncodingTypeUnknown | qualifier;

    switch (*type) {
        case 'v': return WXDBEncodingTypeVoid | qualifier;
        case 'B': return WXDBEncodingTypeBool | qualifier;
        case 'c': return WXDBEncodingTypeInt8 | qualifier;
        case 'C': return WXDBEncodingTypeUInt8 | qualifier;
        case 's': return WXDBEncodingTypeInt16 | qualifier;
        case 'S': return WXDBEncodingTypeUInt16 | qualifier;
        case 'i': return WXDBEncodingTypeInt32 | qualifier;
        case 'I': return WXDBEncodingTypeUInt32 | qualifier;
        case 'l': return WXDBEncodingTypeInt32 | qualifier;
        case 'L': return WXDBEncodingTypeUInt32 | qualifier;
        case 'q': return WXDBEncodingTypeInt64 | qualifier;
        case 'Q': return WXDBEncodingTypeUInt64 | qualifier;
        case 'f': return WXDBEncodingTypeFloat | qualifier;
        case 'd': return WXDBEncodingTypeDouble | qualifier;
        case 'D': return WXDBEncodingTypeLongDouble | qualifier;
        case '#': return WXDBEncodingTypeClass | qualifier;
        case ':': return WXDBEncodingTypeSEL | qualifier;
        case '*': return WXDBEncodingTypeCString | qualifier;
        case '^': return WXDBEncodingTypePointer | qualifier;
        case '[': return WXDBEncodingTypeCArray | qualifier;
        case '(': return WXDBEncodingTypeUnion | qualifier;
        case '{': return WXDBEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return WXDBEncodingTypeBlock | qualifier;
            else
                return WXDBEncodingTypeObject | qualifier;
        }
        default: return WXDBEncodingTypeUnknown | qualifier;
    }
}

/// Parse a number value from 'id'.
NSNumber *WXDBNSNumberCreateFromID(__unsafe_unretained id value) {
    static NSCharacterSet *dot;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
        dic = @{@"TRUE" :   @(YES),
                @"True" :   @(YES),
                @"true" :   @(YES),
                @"FALSE" :  @(NO),
                @"False" :  @(NO),
                @"false" :  @(NO),
                @"YES" :    @(YES),
                @"Yes" :    @(YES),
                @"yes" :    @(YES),
                @"NO" :     @(NO),
                @"No" :     @(NO),
                @"no" :     @(NO),
                @"NIL" :    (id)kCFNull,
                @"Nil" :    (id)kCFNull,
                @"nil" :    (id)kCFNull,
                @"NULL" :   (id)kCFNull,
                @"Null" :   (id)kCFNull,
                @"null" :   (id)kCFNull,
                @"(NULL)" : (id)kCFNull,
                @"(Null)" : (id)kCFNull,
                @"(null)" : (id)kCFNull,
                @"<NULL>" : (id)kCFNull,
                @"<Null>" : (id)kCFNull,
                @"<null>" : (id)kCFNull};
    });
    
    if (!value || value == (id)kCFNull) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSNumber *num = dic[value];
        if (num) {
            if (num == (id)kCFNull) return nil;
            return num;
        }
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            double num = atof(cstring);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        } else {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            return @(atoll(cstring));
        }
    }
    return nil;
}


/// Get the Foundation class type from property info.
WXDBEncodingNSType WXDBClassGetNSType(Class cls) {
    if (!cls) return WXDBEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return WXDBEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return WXDBEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return WXDBEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return WXDBEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return WXDBEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return WXDBEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return WXDBEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return WXDBEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return WXDBEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return WXDBEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return WXDBEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return WXDBEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return WXDBEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return WXDBEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return WXDBEncodingTypeNSSet;
    return WXDBEncodingTypeNSUnknown;
}



@implementation WXDataBindTools

@end
