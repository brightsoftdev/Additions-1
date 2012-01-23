//
//  NSOject+Additions.h
//
//  Created by Kevin Musselman on 6/23/11.
//  Copyright 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WorkerBlock)(void);
typedef NSArray* (^returnArrayBlock)(void);
typedef void (^callbackWithArray)(NSArray *);

typedef UIImage* (^returnImgBlock)(void);
typedef void (^callbackWithImg)(UIImage *);

@interface NSObject(Additions)

- (void)dispatchWorker:(WorkerBlock)worker withCallback:(WorkerBlock)callback;
+ (void)dispatchWorker:(WorkerBlock)worker withCallback:(WorkerBlock)callback;

- (void)dispatchGenericWorker:(returnImgBlock)worker withCallback:(callbackWithImg)callback;
- (void)dispatchObjWorker:(returnArrayBlock)worker withCallback:(callbackWithArray)callback;
@end
