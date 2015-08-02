#import "TimeFrame+Business.h"

#import "LocalizableStrings.h"

@implementation TimeFrame (Business)

- (NSString *)description {
	if ([self.startDate isEqual:[NSDate distantPast]]) {
		if ([self.endDate isEqual:[NSDate distantFuture]]) {
			return STRING_WHENEVER;
		} else {
			return [NSString stringWithFormat:STRING_UNTIL, self.endDate.description];
		}
	} else {
		if ([self.endDate isEqual:[NSDate distantFuture]]) {
			return [NSString stringWithFormat:STRING_FROMONWARDS, self.startDate.description];
		} else {
			return [NSString stringWithFormat:STRING_FROMTO, self.startDate.description, self.endDate.description];
		}
	}
	
	return [super description];
}

@end
