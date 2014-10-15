//
//  TVC_ListTasksDependencies.m
//  MindMap
//
//  Created by Pedro Borges on 03/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListDependencies.h"

#import "LocalizedStrings.h"

#define CELL_DIRECTDEPENDENCY @"pt.pcb.mindmap.dependency"
#define CELL_POSSIBLEDEPENDENCY @"pt.pcb.mindmap.possibleDependency"

@implementation TVC_ListDependencies

#pragma mark - Bindings

- (void)bindToView {
	NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dependantsCount" ascending:YES]];
	
	self.list = [self.model.dependencies sortedArrayUsingDescriptors:sortDescriptors];

	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return [self.list count];
		case 1: return [[self.model possibleDependenciesInSameProject] count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_DIRECTDEPENDENCY];
			
			Task *task = (Task *)[self.list objectAtIndex:indexPath.row];
			
			cell.textLabel.text = task.title;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			if (task.completion) {
				cell.textLabel.enabled = NO;
			}
			
			return cell;
		}
		case 1: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_POSSIBLEDEPENDENCY];
			
			Task *task = (Task *)[[self.model possibleDependenciesInSameProject] objectAtIndex:indexPath.row];
			
			UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:TAG_TITLE];

			titleLabel.text = task.title;
			
			return cell;
		}
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return STRING_DIRECTDEPENDENCIES;
		case 1: return STRING_POSSIBLEDEPENDENCIES;
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		Task *dependency = [self.list objectAtIndex:indexPath.row];

		[self.model removeDependenciesObject:dependency];

		[self bindToView]; //todo check if bindToView is needed
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section > 0) {
		Task *dependency = [[self.model possibleDependenciesInSameProject] objectAtIndex:indexPath.row];

		[self.model addDependenciesObject:dependency];

		[self bindToView]; //todo check if bindToView is needed
	}
}

#pragma mark - Navigation

@end