#import "Project.h"

@interface Project (Implementation)

+ (Project *)createFromContext:(NSManagedObjectContext *)context
                      withName:(NSString *)name;
+ (NSArray *)allInContext:(NSManagedObjectContext *)context
		matchingPredicate:(NSPredicate *)predicate;
+ (NSArray *)forName:(NSString *)name
		   inContext:(NSManagedObjectContext *)context;

- (NSArray *)pendingTasks;

- (NSPredicate *)pastTasksPredicate;
- (NSPredicate *)presentTasksPredicate;
- (NSPredicate *)futureTasksPredicate;

@end
