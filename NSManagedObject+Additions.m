//
//  NSManagedObject+Additions.m
//
//  Created by Wess Cope on 9/23/11.
//  Copyright 2012. All rights reserved.
//

#import "NSManagedObject+Additions.h"

static NSManagedObjectContext *context = nil;

@implementation NSManagedObject(Additions)

//#pragma mark - Class methods
//+ (void)setContext:(NSManagedObjectContext *)context;
//+ (NSManagedObjectContext *)context;
//+ (NSString *)name;
//+ (NSEntityDescription *)description;
//+ (id)new;
//+ (id)new:(NSDictionary *)details;
//+ (id)count;
//+ (id)all;
//+ (id)filterWithPredicate:(NSPredicate *)predicate;
//+ (id)filterWithSortDescriptors:(NSArray *)sortDescriptors;
//+ (id)filterWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
//+ (id)getWithPredicate:(NSPredicate *)predicate;
//+ (id)deleteAll;
//
//#pragma mark - Instance methods
//- (BOOL)save;



#pragma mark - Class Methods
+ (void)setContext:(NSManagedObjectContext *)aContext
{
    context = aContext;
}

+ (NSManagedObjectContext *)context
{
//#warning RETURN SINGLETON INSTANCE OF managedObjectContext;
    if (context == nil) 
        return [WCCoreData instance].managedObjectContext;

    return context;
}

- (NSManagedObjectContext *)context
{
    return [[self class] context];
}

+ (NSString *)name
{
    return [NSString stringWithCString:object_getClassName(self) encoding:NSASCIIStringEncoding];
}

+ (NSEntityDescription *)description
{
    return [NSEntityDescription entityForName:[self name] inManagedObjectContext:[self context]];
}

+ (id)new
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:[self context]];
}

+ (id)new:(NSDictionary *)details
{
    id instance = [self new];
    
    [details each:^(id key, id obj) {
        [instance setValue:obj forKey:key]; 
    }];
    
    return instance;
}

+ (NSNumber *)count
{
    return [self countwithPredicate:nil];
}

+ (NSNumber *)countwithPredicate:(NSPredicate *)predicate
{
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[self description] predicate:predicate];
    int cnt = [[self context] countForFetchRequest:request error:&error];
    
    return [NSNumber numberWithInt:cnt];
}

+ (NSArray *)all
{
    return [[self context] fetchObjectsForEntity:[self name]];
}

+ (id)filterWithPredicate:(NSPredicate *)predicate
{
    return [self filterWithPredicate:predicate sortDescriptors:nil];
}

+ (id)filterWithSortDescriptors:(NSArray *)sortDescriptors
{
    return [self filterWithPredicate:nil sortDescriptors:sortDescriptors];
}

+ (id)filterWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    return [[self context] fetchObjectsForEntity:[self name] predicate:predicate sortDescriptors:sortDescriptors];
}

+ (id)getWithPredicate:(NSPredicate *)predicate
{
    return [[self context] fetchObjectForEntity:[self name] predicate:predicate];
}

+ (void)deleteAll
{
    [[self all] each:^(id item){
        [[self context] deleteObject:(NSManagedObject *)item];
    }];
}

#pragma mark - Instance methods
- (BOOL)save
{
    NSError *error = nil;
    
    if(![[self context] save:&error])
    {
        NSLog(@"CoreData save error: %@", [error userInfo]);
        return NO;
    }

    return YES;
}

@end
