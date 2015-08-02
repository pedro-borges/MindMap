#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSData * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
