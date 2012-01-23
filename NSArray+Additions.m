//
//  NSArray+Additions.m
//
//  Created by Wess Cope on 6/3/11.
//  Copyright 2012. All rights reserved.
//

#import "NSArray+Additions.h"


@implementation NSArray(Additions)

- (void)each:(EachCallback)block
{
    for(id item in self)
        block(item);
}

- (NSArray *)select:(ValidationCallback)callback
{
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for(id item in self)
    {
        if(callback(item))
            [results addObject:item];
    }
    
    if(results.count)
    {
        return [[results copy] autorelease];
    }
    else
    {
        [results release];
        return nil;
    }
        
}

@end
