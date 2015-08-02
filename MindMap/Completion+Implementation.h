#import "Completion.h"

#import "Task+Implementation.h"

@interface Completion (Implementation)

+ (Completion *)createFromContext:(NSManagedObjectContext *)context
						  forTask:(Task *)task;

@end
