#import "Task+Business.h"

#import "TimeFrame+Business.h"
#import "Completion+Business.h"

#import "LocalizableStrings.h"

#import "Database.h"

@implementation Task (Business)

- (BOOL)inPresent {
	if (self.completion != nil) return NO;
	
	for (Task *dependency in self.dependencies) {
		if (dependency.completion == nil) return NO;
	}
	
	return YES;
}

- (int)level {
	int result;
NSLog(@"Leveling %@", self.title);
	if (self.completion == nil) {
		// Present or Future
		result = -1;
		
		for (Task *dependency in self.dependencies) {
			if (dependency.completion == nil) {
				int level = [dependency level];
				result = MAX(level, result);
			}
		}
		
		result++;
	} else {
		result = 0;
		
		for (Task *dependant in self.dependants) {
			if (dependant.completion != nil) {
				int level = [dependant level];
				result = MIN(level, result);
			}
		}

		result--;
	}
NSLog(@"}");
	return result;
}

- (NSSet *)fullDependencies {
	NSMutableSet *result = [[NSMutableSet alloc] init];

	[result addObject:self];

	for(Task *dependency in self.dependencies) {
		[result unionSet:[dependency fullDependencies]];
	}

	return result;
}

- (NSArray *)possibleDependenciesInSameProject {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (completion == nil)", self.project];
	
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

- (NSArray *)possibleDependantsInSameProject {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (completion == nil)", self.project, [NSDate date]];

	NSMutableArray *result = [[Task allInContext:self.managedObjectContext matchingPredicate:predicate] mutableCopy];

	for (Task *dependant in [self fullDependants]) {
		[result removeObject:dependant];
	}

	return result;
}

- (NSDate *)enforcedStartDate {
	NSDate *result = self.timeFrame.startDate;

	for (Task *dependency in self.dependencies) {
		if ([dependency.enforcedStartDate compare:result] == NSOrderedDescending) result = dependency.enforcedStartDate;
	}

	if ([result compare:self.timeFrame.startDate] == NSOrderedDescending) {
		self.timeFrame.startDate = result;
	}

	return result;
}

- (NSDate *)enforcedEndDate {
	NSDate *result = self.timeFrame.endDate;

	for (Task *dependant in self.dependants) {
		if ([dependant.enforcedEndDate compare:result] == NSOrderedAscending) result = dependant.enforcedEndDate;
	}

	if ([result compare:self.timeFrame.endDate] == NSOrderedAscending) {
		self.timeFrame.endDate = result;
	}

	return result;
}

- (NSString *)dependenciesDescription {
	NSInteger activeDependenciesCount = self.activeDependenciesCount;

	if (activeDependenciesCount > 0) {
		if (activeDependenciesCount == 1) {
			Task *singleDependency = (Task *)[self.activeDependencies firstObject];
			return [NSString stringWithFormat:STRING_DEPENDENCYDETAIL, [singleDependency.title lowercaseString]];
		} else {
			return [NSString stringWithFormat:STRING_DEPENDENCIESDETAIL, (unsigned long)activeDependenciesCount];
		}
	}

	if ([self.timeFrame.startDate compare:[NSDate date]] == NSOrderedDescending) {
		return STRING_WAITING;
	} else {
		return STRING_ACTIVE;
	}
}

- (NSString *)dependantsDescription {
	NSInteger dependantsCount = self.dependantsCount;

	if (dependantsCount > 0) {
		if (dependantsCount == 1) {
			Task *singleDependant = (Task *)[self.dependants anyObject];
			return [NSString stringWithFormat:STRING_DEPENDANTDETAIL, [singleDependant.title lowercaseString]];
		} else {
			return [NSString stringWithFormat:STRING_DEPENDANTSDETAIL, (unsigned long)dependantsCount];
		}
	}

	return STRING_GOAL;
}

- (void)close {
	self.completion = [Completion createFromContext:self.managedObjectContext
											forTask:self];
	
	[Database saveManagedObjectByForce:self.completion];
	[Database saveManagedObjectByForce:self];
}

- (void)delete {
	[self.managedObjectContext deleteObject:self];
}

@end
