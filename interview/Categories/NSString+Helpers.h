//
//  NSString+Helpers.h
//  WordPress
//
//  Created by John Bickerstaff on 9/9/09.
// //

#import <UIKit/UIKit.h>

@interface NSString (Helpers)

// helper functions
- (NSString *) stringByUrlDecoding;
- (NSString *) stringByUrlEncoding;
- (NSString *) base64Encoding;

@end
