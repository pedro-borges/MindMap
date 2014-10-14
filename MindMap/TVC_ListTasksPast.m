//
//  TVC_ListTasksPast.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasksPast.h"

#import "TimeFrame+Business.h"
#import "Completion+Business.h"

#import "NSDate+Friendly.h"

@implementation TVC_ListTasksPast

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	self.predicate = self.project.pastTasksPredicate;

	[super viewWillAppear:animated];
}

#pragma mark - Implementations

- (NSString *)cellTextFor:(Task *)task {
	return task.title;
}

- (NSString *)cellDetailTextFor:(Task *)task {
	NSString *activeTime = [NSDate describeTimeFrom:[NSDate date] to:task.completion.timestamp];

	return [NSString stringWithFormat:@"Finnished %@", activeTime];
}

@end
