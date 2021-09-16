//
//  WXDataBindDefine.h
//  MVVMDataBind
//
//  Created by zk on 2021/9/15.
//

#ifndef WXDataBindDefine_h
#define WXDataBindDefine_h


/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, WXDBEncodingType) {
    WXDBEncodingTypeMask       = 0xFF, ///< mask of type value
    WXDBEncodingTypeUnknown    = 0, ///< unknown
    WXDBEncodingTypeVoid       = 1, ///< void
    WXDBEncodingTypeBool       = 2, ///< bool
    WXDBEncodingTypeInt8       = 3, ///< char / BOOL
    WXDBEncodingTypeUInt8      = 4, ///< unsigned char
    WXDBEncodingTypeInt16      = 5, ///< short
    WXDBEncodingTypeUInt16     = 6, ///< unsigned short
    WXDBEncodingTypeInt32      = 7, ///< int
    WXDBEncodingTypeUInt32     = 8, ///< unsigned int
    WXDBEncodingTypeInt64      = 9, ///< long long
    WXDBEncodingTypeUInt64     = 10, ///< unsigned long long
    WXDBEncodingTypeFloat      = 11, ///< float
    WXDBEncodingTypeDouble     = 12, ///< double
    WXDBEncodingTypeLongDouble = 13, ///< long double
    WXDBEncodingTypeObject     = 14, ///< id
    WXDBEncodingTypeClass      = 15, ///< Class
    WXDBEncodingTypeSEL        = 16, ///< SEL
    WXDBEncodingTypeBlock      = 17, ///< block
    WXDBEncodingTypePointer    = 18, ///< void*
    WXDBEncodingTypeStruct     = 19, ///< struct
    WXDBEncodingTypeUnion      = 20, ///< union
    WXDBEncodingTypeCString    = 21, ///< char*
    WXDBEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    WXDBEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    WXDBEncodingTypeQualifierConst  = 1 << 8,  ///< const
    WXDBEncodingTypeQualifierIn     = 1 << 9,  ///< in
    WXDBEncodingTypeQualifierInout  = 1 << 10, ///< inout
    WXDBEncodingTypeQualifierOut    = 1 << 11, ///< out
    WXDBEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    WXDBEncodingTypeQualifierByref  = 1 << 13, ///< byref
    WXDBEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    WXDBEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    WXDBEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    WXDBEncodingTypePropertyCopy         = 1 << 17, ///< copy
    WXDBEncodingTypePropertyRetain       = 1 << 18, ///< retain
    WXDBEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    WXDBEncodingTypePropertyWeak         = 1 << 20, ///< weak
    WXDBEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    WXDBEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    WXDBEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/// Foundation Class Type
typedef NS_ENUM (NSUInteger, WXDBEncodingNSType) {
    WXDBEncodingTypeNSUnknown = 0,
    WXDBEncodingTypeNSString,
    WXDBEncodingTypeNSMutableString,
    WXDBEncodingTypeNSValue,
    WXDBEncodingTypeNSNumber,
    WXDBEncodingTypeNSDecimalNumber,
    WXDBEncodingTypeNSData,
    WXDBEncodingTypeNSMutableData,
    WXDBEncodingTypeNSDate,
    WXDBEncodingTypeNSURL,
    WXDBEncodingTypeNSArray,
    WXDBEncodingTypeNSMutableArray,
    WXDBEncodingTypeNSDictionary,
    WXDBEncodingTypeNSMutableDictionary,
    WXDBEncodingTypeNSSet,
    WXDBEncodingTypeNSMutableSet,
};



#endif /* WXDataBindDefine_h */
