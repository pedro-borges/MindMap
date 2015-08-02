#import "TVC_ListTasksPast.h"

#import "TimeFrame+Business.h"
#import "Completion+Business.h"

#import "NSDate+Friendly.h"

#import "LocalizableStrings.h"

@implementation TVC_ListTasksPast

#pragma mark - Bindings

- (void)bindToView {
	self.predicate = self.project.pastTasksPredicate;
	
	[super bindToView];
}

#pragma mark - Implementations

- (NSString *)cellDetailTextFor:(Task *)task {
	NSString *activeTime = [NSDate describeTimeFrom:[NSDate date] to:task.completion.timestamp];

	return [NSString stringWithFormat:STRING_FINNISHEDTIMESTAMP, activeTime];
}

@end
