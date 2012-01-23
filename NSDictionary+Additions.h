//
//  NSDictionary+Additions.h
//
//  Created by Wess Cope on 6/3/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KeyValueCallback)(id key, id obj);

@interface NSDictionary(Additions)

- (void)each: (KeyValueCallback)block;

@end
