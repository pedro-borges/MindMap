#import "Task+Implementation.h"

@interface Task (Business)

- (NSSet *)fullDependencies;
- (NSArray *)possibleDependenciesInSameProject;
- (NSSet *)fullDependants;
- (NSArray *)possibleDependantsInSameProject;

@property (nonatomic, readonly) NSDate *enforcedStartDate;
@property (nonatomic, readonly) NSDate *enforcedEndDate;

@property (nonatomic, readonly) BOOL inPresent;

@property (nonatomic, readonly) NSString *dependenciesDescription;
@property (nonatomic, readonly) NSString *dependantsDescription;

- (void)close;

- (void)delete;

- (int)level;

@end
