//
//  NSFetchRequest+Additions.m
//
//  Created by Wess Cope on 9/23/11.
//  Copyright 2012. All rights reserved.
//

#import "NSFetchRequest+Additions.h"

@implementation NSFetchRequest(Additions)
+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity
{
    return [[[self alloc] initWithEntity:entity predicate:nil sortDescriptors:nil] autorelease];
}

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity predicate:(NSPredicate *)predicate
{
    return [[[self alloc] initWithEntity:entity predicate:predicate sortDescriptors:nil] autorelease];
}

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity sortDescriptors:(NSArray *)sortDescriptors
{
    return [[[self alloc] initWithEntity:entity predicate:nil sortDescriptors:sortDescriptors] autorelease];
}

+ (id)fetchRequestWithEntity:(NSEntityDescription *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    return [[[self alloc] initWithEntity:entity predicate:predicate sortDescriptors:sortDescriptors] autorelease];
}

- (id)initWithEntity:(NSEntityDescription *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    self = [super init];
    if(self)
    {
        self.entity = entity;
        self.predicate = predicate;
        self.sortDescriptors = sortDescriptors;
    }
    
    return self;
}

@end
