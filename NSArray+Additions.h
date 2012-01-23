//
//  NSArray+Additions.h
//
//  Created by Wess Cope on 6/3/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EachCallback)(id item);
typedef BOOL(^ValidationCallback)(id obj);

@interface NSArray(Additions)

- (void)each:(EachCallback)block;
- (NSArray *)select:(ValidationCallback)callback;

@end

