#import <Foundation/Foundation.h>

@interface NSDate (Friendly)

+ (NSString *)describeDateFrom:(NSDate *)startDate
							to:(NSDate *)endDate;
+ (NSString *)describeTimeFrom:(NSDate *)referenceDate
							to:(NSDate *)relativeDate;

@end
