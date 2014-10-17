//
//  NSDate+Friendly.m
//  MindMap
//
//  Created by Pedro Borges on 11/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "NSDate+Friendly.h"

#import "LocalizableStrings.h"

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
			return STRING_WHENEVER;
		} else {
			return [NSString stringWithFormat:STRING_UNTIL, endDate.description];
		}
	} else {
		if ([endDate isEqualToDate:[NSDate distantFuture]]) {
			return [NSString stringWithFormat:STRING_FROMONWARDS, startDate.description];
		} else {
			return [NSString stringWithFormat:STRING_FROMTO, startDate.description, endDate.description];
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
	
	if (years > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_INYEARS, years];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_YEARSAGO, years];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}
	if (years == 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_NEXTYEAR];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_LASTYEAR];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}
	if (months > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_INMONTHS, months];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_MONTHSAGO, months];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}
	if (months == 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_NEXTMONTH];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_LASTMONTH];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}
	if (days > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_INDAYS, days];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_DAYSAGO, days];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}
	if (days == 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_TOMORROW];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_YESTERDAY];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}
	if (hours > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_INHOURS, hours];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_HOURSAGO, hours];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}
	if (hours == 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_NEXTHOUR];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_PASTHOUR];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}
	if (minutes > 1) {
		switch (order) {
			case NSOrderedAscending: return [NSString stringWithFormat:STRING_INMINUTES, minutes];
			case NSOrderedDescending: return [NSString stringWithFormat:STRING_MINUTESSAGO, minutes];
			case NSOrderedSame: return nil; // Invalid condition
		}
	}

	switch (order) {
		case NSOrderedAscending: return STRING_RIGHTAWAY;
		case NSOrderedDescending: return STRING_JUSTNOW;
		case NSOrderedSame: return STRING_NOW;
	}
}

- (NSString *)description {
	return [[self dateFormatter] stringFromDate:self];
}

@end
