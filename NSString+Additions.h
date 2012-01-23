//
//  NSString+Additions.h
//
//  Created by Wess Cope on 5/26/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Additions)

- (BOOL) isValidEmail;
- (NSString *)URLEncode;
- (NSString *)escapeHTML;
- (NSString *)unescapeHTML;
- (NSString *)stringByRemovingHTML;
- (NSString *)capitalizeFirstLetter;
- (NSString *) md5;
+ (NSString *) uuid;

// For phone numbers:
+ (NSDictionary *) sharedPhoneFormats;
- (BOOL)canBeInputByPhonePad:(char)c;
- (NSString *)strip:(NSString *)phoneNumber;
- (NSString *)formattedPhoneNumber;
@end
