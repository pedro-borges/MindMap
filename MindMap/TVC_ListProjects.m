//
//  TVC_ListProjects.m
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListProjects.h"

#import "TBC_ManageProject.h"
#import "TVC_ViewProject.h"

#import "Project+Business.h"
#import "Settings.h"

#import "DatabaseManager.h"

#import "LocalizedStrings.h"

#define CELL_PROJECT @"pt.pcb.mindmap.project"

#define SEGUE_VIEWPROJECT @"View Project"

@interface TVC_ListProjects () <UIAlertViewDelegate, UITextFieldDelegate>

@end

@implementation TVC_ListProjects

#pragma mark - Properties

#pragma mark - UIKit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityName = @"Project";
    self.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];
	
	NSString *name = [alertView textFieldAtIndex:0].text;
	
	if (alertView.tag == ALERT_CREATEPROJECT) {
		if (buttonIndex == 1) {
			Project *project = [Project createFromContext:self.context withName:name];
			
			[Settings defaultSettings].selectedProject = project;
			
			[self bindToView]; //todo check if bindToView is needed
		}
	}
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Project *project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_PROJECT forIndexPath:indexPath];
    
    NSInteger taskCount = [project.tasks count];
    NSInteger pendingCount = [project.pendingTasks count];
    NSInteger doneCount = (taskCount - pendingCount);
	NSInteger percent = 100 * doneCount / taskCount;

    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *detailTextLabel = (UILabel *)[cell.contentView viewWithTag:102];
	
    textLabel.text = project.name;
    
    if (taskCount == 0) {
        detailTextLabel.text = STRING_EMPTY;
    } else {
        if (pendingCount > 0) {
			detailTextLabel.text = [NSString stringWithFormat:@"%lu%%", percent];
		} else {
            detailTextLabel.text = STRING_COMPLETED;
        }
    }

    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Project *project = [self.fetchedResultsController objectAtIndexPath:indexPath];

	[Settings defaultSettings].selectedProject = project;

	[self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
											forRowAtIndexPath:(NSIndexPath *)indexPath {
	Project *project = [self.fetchedResultsController objectAtIndexPath:indexPath];

	if ([project.tasks count] > 0) {
		[super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	} else {
		[self.fetchedResultsController.managedObjectContext deleteObject:project];

		[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
	}
}

#pragma mark - Navigation

- (IBAction)createProject:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:STRING_CREATEPROJECT
												message:nil
											   delegate:self
									  cancelButtonTitle:STRING_CANCEL
									  otherButtonTitles:STRING_CREATE, nil];

    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
	alertView.tag = ALERT_CREATEPROJECT;

    [alertView show];
}

#pragma mark - Abastract Implementation

- (void)deleteManagedObject:(NSManagedObject *)managedObject {
	Project *project = (Project *)managedObject;

	[project delete];
}

- (NSString *)confirmDeletionMessage:(NSManagedObject *)managedObject {
	Project *project = (Project *)managedObject;

	return [NSString stringWithFormat:@"Are you sure you want to delete project %@? %li tasks will be erased", project.name, [project.tasks count]];
}

@end
