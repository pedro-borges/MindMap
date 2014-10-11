//
//  Task+Business.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "Task+Business.h"

#import "TimeFrame+Business.h"

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

- (NSDate *)enforcedStartDate {
	NSDate *result = self.timeFrame.startDate;

	for (Task *dependency in self.dependencies) {
		if ([dependency.startDate compare:result] == NSOrderedDescending) result = dependency.startDate;
	}

	NSLog(@"ret sd: %@", result);
	return result;
}

- (NSDate *)enforcedEndDate {
	NSDate *result = self.timeFrame.endDate;

	for (Task *dependant in self.dependants) {
		if ([dependant.endDate compare:result] == NSOrderedAscending) result = dependant.endDate;
	}
	
	return result;
}

- (BOOL)inheritedTimeFrame {
	NSLog(@"Inherited:");
	if (![self.startDate isEqualToDate:self.timeFrame.startDate]) return YES;
	if (![self.endDate isEqualToDate:self.timeFrame.endDate]) return YES;

	NSLog(@"NO");
	return NO;
}

@end
