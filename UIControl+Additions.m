//
//  UIControl+Additions.m
//
//  Created by Wess Cope on 6/3/11.
//  Copyright 2012. All rights reserved.
//

#import <dispatch/dispatch.h>
#import <objc/runtime.h>
#import "UIControl+Additions.h"

@interface UIControlCallback : NSObject
{
    @private
    EventCallback callback;
    UIControlEvents events;
}

- (id)initWithCallback:(EventCallback)block forEvents:(UIControlEvents)controlEvents;
- (void)execute:(id)sender;

@property (copy) EventCallback callback;
@property (assign) UIControlEvents events;

@end

@implementation UIControlCallback
@synthesize callback, events;

- (id)initWithCallback:(EventCallback)block forEvents:(UIControlEvents)controlEvents
{
    self = [super init];
    if(self)
    {
        self.callback = block;
        self.events = controlEvents;
    }
    
    return self;
}

- (void)execute:(id)sender
{
    EventCallback action = self.callback;

    if(action)
        dispatch_async(dispatch_get_main_queue(), ^{ action(sender); });
}

- (void)dealloc
{
    Block_release(callback);
    [super dealloc];
}

@end

@implementation UIControl(Additions)

- (void)on:(UIControlEvents)events callback:(EventCallback)callback
{
    NSMutableArray *currentEvents = objc_getAssociatedObject(self, @"EventBlocks");
    
    if(!currentEvents)
    {
        currentEvents = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, @"EventBlocks", currentEvents, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [currentEvents release];
    }
    
    UIControlCallback *element = [[UIControlCallback alloc] initWithCallback:callback forEvents:events];
    [currentEvents addObject:element];
    [self addTarget:element action:@selector(execute:) forControlEvents:events];
    [element release];
}

- (void)remove:(UIControlEvents)events
{
    NSMutableArray *currentEvents;
    if ((currentEvents = objc_getAssociatedObject(self, @"EventBlocks")))
    {
        [currentEvents removeObjectsInArray:[currentEvents select:^BOOL(id sender) {
            if ([sender isKindOfClass:[UIControlCallback class]])
                return ([(UIControlCallback*)sender events] == events);

            return NO;
        }]];        
    }
}

@end
