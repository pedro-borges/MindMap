#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Completion : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Task *task;

@end
