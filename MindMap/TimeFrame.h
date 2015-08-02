#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface TimeFrame : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) Task *task;

@end
