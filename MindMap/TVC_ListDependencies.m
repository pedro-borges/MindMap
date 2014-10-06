//
//  TVC_ListTasksDependencies.m
//  MindMap
//
//  Created by Pedro Borges on 03/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListDependencies.h"

#define CELL_DIRECTDEPENDENCY @"pt.pcb.mindmap.dependency"
#define CELL_POSSIBLEDEPENDENCY @"pt.pcb.mindmap.possibleDependency"

#define STRING_DIRECTDEPENDENCIES NSLocalizedString(@"Direct Dependencies", nil)
#define STRING_POSSIBLEDEPENDENCIES NSLocalizedString(@"Possible Dependencies", nil)

@implementation TVC_ListDependencies

#pragma mark - Implementation

- (void)bindToView {
	NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dependenciesCount" ascending:YES]];
	
	self.list = [self.model.dependencies sortedArrayUsingDescriptors:sortDescriptors];

	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return [self.list count];
		case 1: return [[self.model possibleDependencies] count];
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
			
			return cell;
		}
		case 1: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_POSSIBLEDEPENDENCY];
			
			Task *task = (Task *)[[self.model possibleDependencies] objectAtIndex:indexPath.row];
			
			cell.textLabel.text = task.title;
			
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
	switch (indexPath.section) {
		case 0: [self delDependency:[self.list objectAtIndex:indexPath.row]];
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 1: [self addDependency:[[self.model possibleDependencies] objectAtIndex:indexPath.row]];
	}
}

#pragma mark - Navigation

- (void)delDependency:(Task *)dependency {
	[self.model removeDependenciesObject:dependency];

	[self bindToView];
}

- (void)addDependency:(Task *)dependency {
	[self.model addDependenciesObject:dependency];

	[self bindToView];
}

@end