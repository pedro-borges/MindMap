#import "Task.h"

@interface Task (Implementation)

+ (Task *)createFromContext:(NSManagedObjectContext *)context
				 forProject:(Project *)project
                  withTitle:(NSString *)title;
+ (NSArray *)allInContext:(NSManagedObjectContext *)context
		 matchingPredicate:(NSPredicate *)predicate;
+ (NSInteger)countInContext:(NSManagedObjectContext *)context
		  matchingPredicate:(NSPredicate *)predicate;

- (NSInteger)dependantsCount;
- (NSArray *)activeDependencies;
- (NSInteger)activeDependenciesCount;

@end
