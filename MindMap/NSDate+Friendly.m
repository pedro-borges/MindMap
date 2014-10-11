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


+ (NSString *)describeTimeFrom:(NSDate *)startDate
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

- (NSString *)description {
	return [[self dateFormatter] stringFromDate:self];
}

@end
