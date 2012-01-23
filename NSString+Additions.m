//
//  NSString+Additions.m
//
//  Created by Wess Cope on 5/26/11.
//  Copyright 2012. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Additions)

- (BOOL)isValidEmail
{
    NSString *emailRegex =  @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"  
                            @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" 
                            @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"  
                            @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"  
                            @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"  
                            @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"  
                            @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";  
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:[self lowercaseString]];
}

- (NSString *)URLEncode
{
    NSString* encodedString = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL,(CFStringRef)@":/=,!$&'()*+;[]@#?",  kCFStringEncodingUTF8);
    return [NSMakeCollectable(encodedString) autorelease];
}

- (NSString *)escapeHTML
{
	NSMutableString *s = [NSMutableString string];
    
	int start = 0;
	int len = [self length];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
    
	while (start < len)
    {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) 
        {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
        
		if (start < r.location) 
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
        
		switch ([self characterAtIndex:r.location]) 
        {
			case '<':
				[s appendString:@"&lt;"];
			break;
		
            case '>':
				[s appendString:@"&gt;"];
			break;
                
			case '"':
				[s appendString:@"&quot;"];
            break;

			case '&':
				[s appendString:@"&amp;"];
			break;
		}
        
		start = r.location + 1;
	}
    
	return s;
}

- (NSString *)unescapeHTML
{
	NSMutableString *s = [NSMutableString string];
	NSMutableString *target = [[self mutableCopy] autorelease];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    
	while ([target length] > 0) 
    {
		NSRange r = [target rangeOfCharacterFromSet:chs];
	
        if (r.location == NSNotFound) 
        {
			[s appendString:target];
			break;
		}
        
		if (r.location > 0) 
        {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
        
		if ([target hasPrefix:@"&lt;"]) 
        {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} 
        else if ([target hasPrefix:@"&gt;"]) 
        {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} 
        else if ([target hasPrefix:@"&quot;"]) 
        {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} 
        else if ([target hasPrefix:@"&#39;"]) 
        {
			[s appendString:@"'"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} 
        else if ([target hasPrefix:@"&amp;"]) 
        {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} 
        else if ([target hasPrefix:@"&hellip;"]) 
        {
			[s appendString:@"…"];
			[target deleteCharactersInRange:NSMakeRange(0, 8)];
		} 
        else 
        {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
    
	return s;
}


- (NSString*)stringByRemovingHTML
{
    
	NSString *html = self;
    NSScanner *thescanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while (![thescanner isAtEnd]) 
    {
		[thescanner scanUpToString:@"<" intoString:NULL];
		[thescanner scanUpToString:@">" intoString:&text];
		html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@" "];
    }
	return html;
}

- (NSString *)capitalizeFirstLetter
{
    if(![self isEqualToString:@""])
    {
        NSString *firstCapChar = [[self substringToIndex:1] capitalizedString];
        NSString *cappedString = [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
        return cappedString;
    }
    
    return self;
}


#pragma mark - Phone number methods
+ (NSDictionary *) sharedPhoneFormats
{
	static NSDictionary *formats = nil ;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSArray *usPhoneFormats = [NSArray arrayWithObjects:
								   @"+1 (###) ###-####",
								   @"1 (###) ###-####",
								   @"011 $",
								   @"###-####",
								   @"(###) ###-####", nil];

		formats = [[NSDictionary alloc] initWithObjectsAndKeys:
                   usPhoneFormats, @"US",
                   nil];
    });
	
	return formats ;
}


- (BOOL)canBeInputByPhonePad:(char)c 
{
	if(c == '+' || c == '*' || c == '#') return YES;
	if(c >= '0' && c <= '9') return YES;
	return NO;
}

// Strips out invalid characters
- (NSString *)strip:(NSString *)phoneNumber 
{
	NSMutableString *res = [[[NSMutableString alloc] init] autorelease];
	for(int i = 0; i < [phoneNumber length]; i++) 
    {
		char next = [phoneNumber characterAtIndex:i];
		if([self canBeInputByPhonePad:next])
			[res appendFormat:@"%c", next];
    }
	return res;
}


- (NSString *)formattedPhoneNumber
{
	NSString *phoneNumber = self ;
	NSArray *localeFormats = [[NSString sharedPhoneFormats] objectForKey:@"US"];
	if(localeFormats == nil) return phoneNumber;
	NSString *input = [self strip:phoneNumber];
	for(NSString *phoneFormat in localeFormats) 
    {
		int i = 0;
		NSMutableString *temp = [[[NSMutableString alloc] init] autorelease];
		for(int p = 0; temp != nil && i < [input length] && p < [phoneFormat length]; p++) 
        {
			char c = [phoneFormat characterAtIndex:p];
			BOOL required = [self canBeInputByPhonePad:c];
			char next = [input characterAtIndex:i];
			switch(c) 
            {
				case '$':
					p--;
					[temp appendFormat:@"%c", next]; i++;
					break;
				case '#':
					if(next < '0' || next > '9') 
                    {
						temp = nil;
						break;
                    }
					[temp appendFormat:@"%c", next]; i++;
					break;
				default:
					if(required) 
                    {
						if(next != c) 
                        {
							temp = nil;
							break;
                        }
						[temp appendFormat:@"%c", next]; i++;
                    } 
					else 
                    {
						[temp appendFormat:@"%c", c];
						if(next == c) i++;
                    }
                    break;
            }
        } // build temp loop
		if(i == [input length]) 
        {
			return temp;
        }
    } // for each format
	return input;
}

-(NSString*) md5
{
    const char * cstr = [self UTF8String];
    unsigned char result[ CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cstr, strlen( cstr ), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString*) uuid
{
	CFUUIDRef puuid = CFUUIDCreate( nil );
	CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
	CFRelease(puuid);
    CFRelease(uuidString);
    
	return [result autorelease];
}

@end
