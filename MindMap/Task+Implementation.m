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
		NSLog(@"Error getting all Tasks - %@", error);
	}

	return result;
}

- (NSInteger)dependantsCount {
	return [self.dependants count];
}

- (NSInteger)dependenciesCount {
	//TODO change for active dependencies only
	return [self.dependencies count];
}

@end
