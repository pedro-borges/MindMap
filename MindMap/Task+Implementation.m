//
//  Task+Implementation.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Task+Implementation.h"
#import "TimeFrame+Implementation.h"
#import "Database.h"

@implementation Task (Implementation)

+ (Task *)createFromContext:(NSManagedObjectContext *)context
				 forProject:(Project *)project
				  withTitle:(NSString *)title {
    Task *result;
    
    result = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];

	TimeFrame *timeFrame = [TimeFrame createFromContext:context startDate:nil endDate:nil];
	
    result.title = title;
	result.project = project;
	result.timeFrame = timeFrame;
	result.timestamp = [NSDate date];

    [Database saveManagedObjectByForce:result];
    
    return result;
}

+ (NSArray *)allInContext:(NSManagedObjectContext *)context
		 matchingPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];

	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

	request.sortDescriptors = sortDescriptors;
	request.predicate = predicate;

	NSError *error;

	NSArray *result = [context executeFetchRequest:request error:&error];

	if (error) {
		NSLog(@"Error fetching allInContext:matchingPredicate: - %@", error);
	}

	return result;
}

+ (NSInteger)countInContext:(NSManagedObjectContext *)context
		  matchingPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	request.sortDescriptors = sortDescriptors;
	request.predicate = predicate;
	
	NSError *error;
	
	NSInteger result = [context countForFetchRequest:request error:&error];
	
	if (error) {
		NSLog(@"Error fetching countInContext:matchingPredicate - %@", error);
	}

	return result;
}

- (NSInteger)dependantsCount {
	return [self.dependants count];
}

- (NSPredicate *)activeDependenciesPredicate {
	NSDate *now = [NSDate date];

	return [NSPredicate predicateWithFormat:@"(ANY dependants = %@) AND (completion = nil) AND (timeFrame.startDate < %@)", self, now];
}

- (NSInteger)activeDependenciesCount {
	return [Task countInContext:self.managedObjectContext matchingPredicate:[self activeDependenciesPredicate]];
}

- (NSArray *)activeDependencies {
	return [Task allInContext:self.managedObjectContext matchingPredicate:[self activeDependenciesPredicate]];
}

@end
