#import "TimeFrame.h"

@interface TimeFrame (Implementation)

+ (TimeFrame *)createFromContext:(NSManagedObjectContext *)context
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate;

@end
