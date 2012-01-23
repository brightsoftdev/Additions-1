//
//  NSData+Base64.h
//
//  Created by Wess Cope on 5/7/11.
//  Copyright 2012. All rights reserved.
//

@interface NSData (Base64)

+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
- (id) initWithBase64EncodedString:(NSString *) string;
- (NSString *) base64EncodingWithLineLength:(unsigned int) lineLength;

@end