//
//  TVC_Dependants.m
//  MindMap
//
//  Created by Pedro Borges on 03/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListDependants.h"

#define CELL_DIRECTDEPENDANT @"pt.pcb.mindmap.dependant"
#define CELL_POSSIBLEDEPENDANT @"pt.pcb.mindmap.possibleDependant"

#define STRING_DIRECTDEPENDANTS NSLocalizedString(@"Direct Dependants", nil)
#define STRING_POSSIBLEDEPENDANTS NSLocalizedString(@"Possible Dependants", nil)

@implementation TVC_ListDependants
    
#pragma mark - Implementation

- (void)bindToView {
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dependantsCount" ascending:YES]];
    
    self.list = [self.model.dependants sortedArrayUsingDescriptors:sortDescriptors];

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0: return [self.list count];
		case 1: return [[self.model possibleDependants] count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_DIRECTDEPENDANT];

			Task *task = (Task *)[self.list objectAtIndex:indexPath.row];

			cell.textLabel.text = task.title;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			return cell;
		}
		case 1: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_POSSIBLEDEPENDANT];

			Task *task = (Task *)[[self.model possibleDependants] objectAtIndex:indexPath.row];

			cell.textLabel.text = task.title;

			return cell;
		}
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return STRING_DIRECTDEPENDANTS;
		case 1: return STRING_POSSIBLEDEPENDANTS;
	}

	return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: [self delDependant:[self.list objectAtIndex:indexPath.row]];
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 1: [self addDependant:[[self.model possibleDependants] objectAtIndex:indexPath.row]];
	}
}

#pragma mark - Navigation

- (void)delDependant:(Task *)dependant {
	[self.model removeDependantsObject:dependant];
	
	[self bindToView];
}

- (void)addDependant:(Task *)dependant {
	[self.model addDependantsObject:dependant];
	
	[self bindToView];
}

@end
