#import "Database.h"

@implementation Database

+ (void)saveManagedObject:(NSManagedObject *)managedObject {
	NSError *error;
	
	[managedObject.managedObjectContext save:&error];
	
	if (error) {
		NSLog(@"Error saving object - %@", error);
	}
}

+ (void)saveManagedObjectByForce:(NSManagedObject *)managedObject {
	NSManagedObjectContext *context = managedObject.managedObjectContext;

	while (context.parentContext != nil) {
		context = context.parentContext;
	};

	NSError *error;

	[context save:&error];

	if (error) {
		NSLog(@"Error saving object - %@", error);
	}
}

@end