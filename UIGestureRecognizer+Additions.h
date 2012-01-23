//
//  UIGestureRecognizer+Additions.h
//
//  Created by Wess Cope on 6/3/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GestureCallback)(id sender);

@interface UIGestureRecognizer(Additions)

+ (id)withCallback:(GestureCallback)aCallback;
- (id)initWithCallback:(GestureCallback)aCallback;

@property (copy) GestureCallback callback;

@end
