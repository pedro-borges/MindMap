//
//  Task+Business.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Task+Business.h"

@implementation Task (Business)

- (NSSet *)fullDependencies {
	NSMutableSet *result = [[NSMutableSet alloc] init];

	[result addObject:self];

	for(Task *dependency in self.dependencies) {
		[result unionSet:[dependency fullDependencies]];
	}

	return result;
}

- (NSArray *)possibleDependenciesInSameProject {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project = %@", self.project];
	
	NSMutableArray *result = [[Task allInContext:self.managedObjectContext matchingPredicate:predicate] mutableCopy];

	for (Task *dependency in [self fullDependencies]) {
		[result removeObject:dependency];
	}

	return result;
}

- (NSSet *)fullDependants {
	NSMutableSet *result = [[NSMutableSet alloc] init];

	[result addObject:self];

	for(Task *dependant in self.dependants) {
		[result unionSet:[dependant fullDependants]];
	}

	return result;
}

- (NSArray *)possibleDependantsIsSameProject {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"project = %@", self.project];

	NSMutableArray *result = [[Task allInContext:self.managedObjectContext matchingPredicate:predicate] mutableCopy];

	for (Task *dependant in [self fullDependants]) {
		[result removeObject:dependant];
	}

	return result;
}

@end
