//
//  NSManagedObjectContext+Additions.m
//
//  Created by Wess Cope on 9/23/11.
//  Copyright 2012. All rights reserved.
//

#import "NSManagedObjectContext+Additions.h"

@implementation NSManagedObjectContext(Additions)

- (NSManagedObjectModel *)objectModel
{
    return [[self persistentStoreCoordinator] managedObjectModel];
}

#pragma mark - Sync methods
- (NSArray *)fetchObjectsForEntity:(NSString *)entity
{
    return [self fetchObjectsForEntity:entity predicate:nil sortDescriptors:nil];
}

- (NSArray *)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate
{
    return [self fetchObjectsForEntity:entity predicate:predicate sortDescriptors:nil];
}

- (NSArray *)fetchObjectsForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors
{
    return [self fetchObjectsForEntity:entity predicate:nil sortDescriptors:sortDescriptors];
}

- (NSArray *)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self] predicate:predicate sortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    @try 
    {
        NSArray *results = [self executeFetchRequest:request error:&error];

        if(error)
        {
            @throw [NSString stringWithFormat:@"CoreData Fetch error: %@", [error userInfo]];
            return nil;
        }
        
        return results;
        
    }
    @catch (NSException *exception) 
    {
        NSLog(@"Fetch Exception: %@", [exception description]);
    }

    return nil;
}

- (id)fetchObjectForEntity:(NSString *)entity
{
    return [self fetchObjectForEntity:entity predicate:nil sortDescriptors:nil];
}

- (id)fetchObjectForEntity:(NSString *)entity predicate:(NSPredicate *)predicate
{
    return [self fetchObjectForEntity:entity predicate:predicate sortDescriptors:nil];    
}

- (id)fetchObjectForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors
{
    return [self fetchObjectForEntity:entity predicate:nil sortDescriptors:sortDescriptors];
}

- (id)fetchObjectForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    NSArray *results = [self fetchObjectsForEntity:entity predicate:predicate sortDescriptors:sortDescriptors];
    if (results.count < 1)
        return nil;
    
    NSLog(@"results; %@", results);
    return nil; //[results objectAtIndex:0];
}



#pragma mark - Async Methods
- (void)fetchObjectsForEntity:(NSString *)entity callback:(FetchObjectsCallback)callback
{
    [self fetchObjectsForEntity:entity predicate:nil sortDescriptors:nil callback:callback];
}

- (void)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate callback:(FetchObjectsCallback)callback
{
    [self fetchObjectsForEntity:entity predicate:predicate sortDescriptors:nil callback:callback];
}

- (void)fetchObjectsForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors callback:(FetchObjectsCallback)callback
{
    [self fetchObjectsForEntity:entity predicate:nil sortDescriptors:sortDescriptors callback:callback];
}

- (void)fetchObjectsForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors callback:(FetchObjectsCallback)callback
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:self];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntity:entityDescription predicate:predicate sortDescriptors:sortDescriptors];
    
    [self fetchRequest:request withCallback:callback];
}

- (void)fetchObjectForEntity:(NSString *)entity callback:(FetchObjectCallback)callback
{
    [self fetchObjectForEntity:entity predicate:nil sortDescriptors:nil callback:callback];
}

- (void)fetchObjectForEntity:(NSString *)entity predicate:(NSPredicate *)predicate callback:(FetchObjectCallback)callback
{
    [self fetchObjectForEntity:entity predicate:predicate sortDescriptors:nil callback:callback];    
}

- (void)fetchObjectForEntity:(NSString *)entity sortDescriptors:(NSArray *)sortDescriptors callback:(FetchObjectCallback)callback
{
    [self fetchObjectForEntity:entity predicate:nil sortDescriptors:sortDescriptors callback:callback];
}

- (void)fetchObjectForEntity:(NSString *)entity predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors callback:(FetchObjectCallback)callback
{
    [self fetchObjectsForEntity:entity predicate:predicate sortDescriptors:sortDescriptors callback:^(NSArray *objects, NSError *error) {
        id object = nil;
        
        if(objects.count > 0)
            object = [objects objectAtIndex:0];
        
        callback(object, error);
    }];
}


- (void)fetchRequest:(NSFetchRequest *)fetchRequest withCallback:(FetchObjectsCallback)callback
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    
    dispatch_async(GLOBAL_QUEUE, ^{
        
        NSError *error = nil;
        NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *objectIds = [NSMutableArray arrayWithCapacity:objects.count];
        
        [objects each:^(id item) {
            [objectIds addObject:[(NSManagedObject *)item objectID]];
        }];
        
        dispatch_async(MAIN_QUEUE, ^{
            NSMutableArray *resultObjects = [NSMutableArray arrayWithCapacity:objectIds.count];
            
            [objectIds each:^(id item) {
                [resultObjects addObject:[self objectWithID:(NSManagedObjectID *)item]];
            }];
            
            callback([NSArray arrayWithArray:resultObjects], error);
        });
    });
}

#pragma mark - Insert New Entity
- (id)insertEntity:(NSString *)entity
{
    return [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:self];
}

- (void)deleteEntity:(NSString *)entity withPredicate:(NSPredicate *)predicate
{
    NSError __block *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self] predicate:predicate];
    
    NSArray *results = [self executeFetchRequest:fetchRequest error:&error];
    
    [results each:^(id item) {
        NSManagedObject *object = (NSManagedObject *)item;
        if([object validateForDelete:&error])
            NSLog(@"CoreData Delete error: %@", [error userInfo]);
        else
            [self deleteObject:object];
    }];
    
    [self save:&error];
}


@end
