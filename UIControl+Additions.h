//
//  UIControl+Additions.h
//
//  Created by Wess Cope on 6/3/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EventCallback)(id sender);

@interface UIControl(Additions)

- (void)on:(UIControlEvents)event callback:(EventCallback)callback;
- (void)remove:(UIControlEvents)events;

@end
