//
//  UIGestureRecognizer+Additions.m
//
//  Created by Wess Cope on 6/3/11.
//  Copyright 2012. All rights reserved.
//

#import "UIGestureRecognizer+Additions.h"
#import <objc/runtime.h>

@interface UIGestureRecognizer(Private)
- (void) executeCallback:(id)sender;
@end

@implementation UIGestureRecognizer(Additions)

+ (id)withCallback:(GestureCallback)aCallback
{
    return [[[[self class] alloc] initWithCallback:aCallback] autorelease];
}

- (id)initWithCallback:(GestureCallback)aCallback
{
    
    self = [self initWithTarget:self action:@selector(executeCallback:)];
    [self setCallback:aCallback];
    
    return self;
}

- (void) executeCallback:(id)sender
{
    GestureCallback tmpCallback = self.callback;
    if(tmpCallback)
        tmpCallback(self);
}

- (void)setCallback:(GestureCallback)aCallback
{
    objc_setAssociatedObject(self, @"gCallback_", aCallback, OBJC_ASSOCIATION_COPY);
}

- (GestureCallback)callback
{
    return objc_getAssociatedObject(self, @"gCallback_");
}

@end
