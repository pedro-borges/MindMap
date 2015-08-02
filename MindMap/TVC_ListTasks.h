#import "TVC_List_CoreData.h"
#import "Task+Business.h"
#import "Project+Business.h"

#define ALERT_TASK 100
#define ALERT_CREATEDEPENDANT 101
#define ALERT_NOTIFICATION 102

@interface TVC_ListTasks : TVC_List_CoreData

@property (nonatomic, readonly) Project *project;

- (NSString *)cellTextFor:(Task *)task;
- (NSString *)cellDetailTextFor:(Task *)task;

- (void)createDependantToSelectedTask:(NSString *)title;

@end
