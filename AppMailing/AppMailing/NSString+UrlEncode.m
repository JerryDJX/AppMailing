//
//  NSString+UrlEncode.m
//  AppMailing
//
//  Created by KANG HAN on 2021/2/24.
//

#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)
- (NSString *)URLEncodedString
{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}



/**
 *  URLDecode
 */
-(NSString *)URLDecodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString = [self stringByRemovingPercentEncoding];
    return decodedString;
}
@end
