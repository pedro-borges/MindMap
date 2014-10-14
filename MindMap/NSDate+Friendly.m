//
//  NSDate+Friendly.m
//  MindMap
//
//  Created by Pedro Borges on 11/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "NSDate+Friendly.h"

@implementation NSDate (Friendly)

NSDateFormatter *_dateFormatter;

- (NSDateFormatter *)dateFormatter {
	if(_dateFormatter == nil) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		_dateFormatter.dateFormat = @"yyyy/MM/dd";
	}
	
	return _dateFormatter;
}


+ (NSString *)describeDateFrom:(NSDate *)startDate
							to:(NSDate *)endDate {
	
	if ([startDate isEqualToDate:[NSDate distantPast]]) {
		if ([endDate isEqualToDate:[NSDate distantFuture]]) {
			return @"Whenever";
		} else {
			return [NSString stringWithFormat:@"Until %@", endDate.description];
		}
	} else {
		if ([endDate isEqualToDate:[NSDate distantFuture]]) {
			return [NSString stringWithFormat:@"From %@ onwards", startDate.description];
		} else {
			return [NSString stringWithFormat:@"From %@ to %@", startDate.description, endDate.description];
		}
	}
}

+ (NSString *)describeTimeFrom:(NSDate *)referenceDate to:(NSDate *)relativeDate {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	//TODO review why cast is needed to avoid warning, also recheck after xcode upgrades
	NSCalendarUnit units = (NSCalendarUnit)(NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
	NSDateComponents *components = [gregorian components:units fromDate:referenceDate toDate:relativeDate options:NSWrapCalendarComponents];

	NSInteger years		= ABS(components.year);
	NSInteger months	= ABS(components.month);
	NSInteger days		= ABS(components.day);
	NSInteger hours		= ABS(components.hour);
	NSInteger minutes	= ABS(components.minute);

	NSComparisonResult order = [referenceDate compare:relativeDate];

	if (order == NSOrderedSame) {
		return @"Now";
	}

	if (years > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"in %li years", years];
			case NSOrderedDescending: return [NSString stringWithFormat:@"%li years ago", years];
			case NSOrderedSame:;
		}
	}
	if (years == 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"next year"];
			case NSOrderedDescending: return [NSString stringWithFormat:@"last year"];
			case NSOrderedSame:;
		}
	}
	if (months > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"in %li months", months];
			case NSOrderedDescending: return [NSString stringWithFormat:@"%li months ago", months];
			case NSOrderedSame:;
		}
	}
	if (months == 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"next month"];
			case NSOrderedDescending: return [NSString stringWithFormat:@"last month"];
			case NSOrderedSame:;
		}
	}
	if (days > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"in %li days", days];
			case NSOrderedDescending: return [NSString stringWithFormat:@"%li days ago", days];
			case NSOrderedSame:;
		}
	}
	if (days == 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"tomorrow"];
			case NSOrderedDescending: return [NSString stringWithFormat:@"yesterday"];
			case NSOrderedSame:;
		}
	}
	if (hours > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"in %li hours", hours];
			case NSOrderedDescending: return [NSString stringWithFormat:@"%li hours ago", hours];
			case NSOrderedSame:;
		}
	}
	if (hours == 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"next hour"];
			case NSOrderedDescending: return [NSString stringWithFormat:@"past hour"];
			case NSOrderedSame:;
		}
	}
	if (minutes > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:@"in %li minutes", minutes];
			case NSOrderedDescending: return [NSString stringWithFormat:@"%li minutes ago", minutes];
			case NSOrderedSame:;
		}
	}

	return @"Just Now";
}

- (NSString *)description {
	return [[self dateFormatter] stringFromDate:self];
}

@end
