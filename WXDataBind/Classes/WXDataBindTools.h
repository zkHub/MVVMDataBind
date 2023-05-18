//
//  WXDataBindTools.h
//  MVVMDataBind
//
//  Created by zk on 2021/9/15.
//

#import <Foundation/Foundation.h>
#import "WXDataBindDefine.h"


NS_ASSUME_NONNULL_BEGIN

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
WXDBEncodingType WXDBEncodingGetType(const char *typeEncoding);


/// Parse a number value from 'id'.
NSNumber *WXDBNSNumberCreateFromID(__unsafe_unretained id value);


/// Get the Foundation class type from property info.
WXDBEncodingNSType WXDBClassGetNSType(Class cls);





@interface WXDataBindTools : NSObject

@end

NS_ASSUME_NONNULL_END
