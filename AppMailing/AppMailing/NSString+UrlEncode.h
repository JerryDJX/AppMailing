//
//  NSString+UrlEncode.h
//  AppMailing
//
//  Created by KANG HAN on 2021/2/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UrlEncode)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
@end

NS_ASSUME_NONNULL_END
