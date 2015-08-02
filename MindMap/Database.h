#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Database : NSObject

+ (void)saveManagedObject:(NSManagedObject *)managedObject;
+ (void)saveManagedObjectByForce:(NSManagedObject *)managedObject;

@end
