//
//  NSOject+Additions.m
//
//  Created by Kevin Musselman on 6/23/11.
//  Copyright 2012. All rights reserved.
//

#import "NSObject+Additions.h"


@implementation NSObject(Additions)


- (void)dispatchWorker:(WorkerBlock)worker withCallback:(WorkerBlock)callback
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{ 
        worker();
        dispatch_async(dispatch_get_main_queue(), ^{ 
            callback();
        });
    });     
}

+ (void)dispatchWorker:(WorkerBlock)worker withCallback:(WorkerBlock)callback
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{ 
        worker();
        dispatch_async(dispatch_get_main_queue(), ^{ 
            callback();
        });
    });     
}

- (void)dispatchGenericWorker:(returnImgBlock)worker withCallback:(callbackWithImg)callback
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{ 
         UIImage* myobj = worker();
        dispatch_async(dispatch_get_main_queue(), ^{ 
            callback(myobj);
        });
    });     
}

- (void)dispatchObjWorker:(returnArrayBlock)worker withCallback:(callbackWithArray)callback
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{ 
    NSArray *temp = worker();
        dispatch_async(dispatch_get_main_queue(), ^{ 
            callback(temp);
        });
    });     
}

@end
