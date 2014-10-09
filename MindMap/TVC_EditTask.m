//
//  TVC_EditTask.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_EditTask.h"

#import "TVC_ListDependencies.h"
#import "TVC_ListDependants.h"

#import "Task+Business.h"
#import "Place+Business.h"
#import "TimeFrame+Business.h"

@interface TVC_EditTask()

@property (nonatomic, weak) IBOutlet UITextField *titleTextField;
@property (nonatomic, weak) IBOutlet UILabel *timeFrameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationsLabel;
@property (nonatomic, weak) IBOutlet UILabel *dependenciesLabel;
@property (nonatomic, weak) IBOutlet UILabel *dependantsLabel;

- (IBAction)saveAction:(UIBarButtonItem *)sender;

@end

@implementation TVC_EditTask

#pragma mark - UIKit

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.firstResponder = self.titleTextField;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self bindToView];

	if (self.firstResponder) {
		[self.firstResponder becomeFirstResponder];

		self.firstResponder = nil;
	}
}

#pragma mark - Overrides

- (Task *)model {
    return (Task *)self.managedObject;
}

- (void)setModel:(Task *)model {
    if (self.managedObject != model) {
        self.managedObject = model;
    }
}

- (void)bindToModel {
    NSString *title = self.titleTextField.text;

    self.model.title = title;

//	[super bindToModel];
}

- (void)bindToView {
    NSString *title = self.model.title;
    NSString *timeFrame = self.model.timeFrame.description;
    NSString *locations = @""; //TODO Location
    NSString *dependencies = [NSString stringWithFormat:@"%lu", (unsigned long)[self.model.dependencies count]];
    NSString *dependants = [NSString stringWithFormat:@"%lu", (unsigned long)[self.model.dependants count]];

    self.titleTextField.text    = title;
    self.timeFrameLabel.text    = timeFrame;
    self.locationsLabel.text    = locations;
    self.dependantsLabel.text   = dependants;
    self.dependenciesLabel.text = dependencies;
}

#pragma mark - Navigation

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
	[self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)saveAction:(UIBarButtonItem *)sender {
    [self bindToModel];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([@"List Dependencies" isEqualToString:segue.identifier]) {
		TVC_ListDependencies *controller = segue.destinationViewController;
		controller.model = self.model;
		controller.navigationItem.title = self.model.title;
	} else 	if ([@"List Dependants" isEqualToString:segue.identifier]) {
		TVC_ListDependants *controller = segue.destinationViewController;
		controller.model = self.model;
		controller.navigationItem.title = self.model.title;
	}
}

@end
