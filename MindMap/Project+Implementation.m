//
//  Project+Implementation.m
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Project+Implementation.h"

#import "Database.h"

@implementation Project (Implementation)

+ (Project *)createFromContext:(NSManagedObjectContext *)context
                      withName:(NSString *)name {
    Project *result;

    result = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:context];

    result.name = name;

    [Database saveManagedObjectByForce:result];

    return result;
}

+ (NSArray *)allInContext:(NSManagedObjectContext *)context
        matchingPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    request.sortDescriptors = sortDescriptors;
    request.predicate = predicate;
    
    NSError *error;
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error getting all Tasks - %@", error);
    }
    
    return result;
}

+ (NSArray *)forName:(NSString *)name
		   inContext:(NSManagedObjectContext *)context {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	request.sortDescriptors = sortDescriptors;
	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	
	NSError *error;
	
	NSArray *result = [context executeFetchRequest:request error:&error];
	
	if (error) {
		NSLog(@"Error getting Task forName:%@ - %@", name, error);
	}
	
	return result;
}

- (NSArray *)pendingTasks {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];

	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

	request.sortDescriptors = sortDescriptors;
	request.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (completion = nil)", self];

	NSError *error;

	NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];

	if (error) {
		NSLog(@"Error getting pending tasks - %@", error);
	}
	
	return result;
}

- (NSArray *)pastTasks {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

	request.sortDescriptors = sortDescriptors;
	request.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (completion != nil)", self];

	NSError *error;
	
	NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
	
	if (error) {
		NSLog(@"Error getting pending tasks - %@", error);
	}
	
	return result;
}

- (NSArray *)presentTasks {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	request.sortDescriptors = sortDescriptors;
	request.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (completion == nil) AND (SUBQUERY(dependencies, $t, $t.completion == nil).@count == 0)", self];
	
	NSError *error;
	
	NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
	
	if (error) {
		NSLog(@"Error getting pending tasks - %@", error);
	}
	
	return result;
}

- (NSArray *)futureTasks {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	request.sortDescriptors = sortDescriptors;
	request.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (SUBQUERY(dependencies, $t, $t.completion == nil).@count > 0)", self];
	
	NSError *error;
	
	NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
	
	if (error) {
		NSLog(@"Error getting pending tasks - %@", error);
	}
	
	return result;
}

@end
