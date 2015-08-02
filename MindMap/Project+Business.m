#import "Project+Business.h"

@implementation Project (Business)

- (void)delete {
	[self.managedObjectContext deleteObject:self];
}

@end
