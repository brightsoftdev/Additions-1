//
//  NSDictionary+Additions.m
//
//  Created by Wess Cope on 6/3/11.
//  Copyright 2012. All rights reserved.
//

#import "NSDictionary+Additions.h"


@implementation NSDictionary(Additions)

- (void)each: (KeyValueCallback)block
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

@end
