//
//  TVC_ListHierarchy.m
//  MindMap
//
//  Created by Pedro Borges on 03/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListHierarchy.h"

#import "Task+Business.h"

#import "LocalizedStrings.h"

@interface TVC_ListHierarchy ()

@end

@implementation TVC_ListHierarchy

#pragma mark - Properties

@synthesize model = _model;

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	Task *task;

	switch (indexPath.section) {
        case 0:
			task = (Task *)[self.list objectAtIndex:indexPath.row];
			return task.completion == nil;
        case 1: return NO;
		case 2: return NO;
    }

    return NO;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return STRING_REMOVE;
}

@end
