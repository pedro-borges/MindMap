//
//  NSDate+Friendly.h
//  MindMap
//
//  Created by Pedro Borges on 11/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Friendly)

+ (NSString *)describeDateFrom:(NSDate *)startDate
							to:(NSDate *)endDate;
+ (NSString *)describeTimeFrom:(NSDate *)referenceDate
							to:(NSDate *)relativeDate;

@end
