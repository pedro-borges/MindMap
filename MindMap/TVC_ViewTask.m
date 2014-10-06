//
//  TVC_ViewTask.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ViewTask.h"

#import "TVC_EditTask.h"

#import "Task+Business.h"
#import "TimeFrame+Business.h"

@interface TVC_ViewTask()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeFrameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationsLabel;
@property (nonatomic, weak) IBOutlet UILabel *dependenciesLabel;
@property (nonatomic, weak) IBOutlet UILabel *dependantsLabel;

@end

@implementation TVC_ViewTask

#pragma mark - Properties

- (Task *)model {
	return (Task *)self.managedObject;
}

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	[self bindToView];
}

#pragma mark - Overrides

- (void)setModel:(Task *)model {
    if (self.managedObject != model) {
        self.managedObject = model;
    }
}

- (void)bindToView {
    NSString *title = self.model.title;
    NSString *timeFrame = self.model.timeFrame.description;
    NSString *locations = @""; //TODO Location
    NSString *dependencies = [NSString stringWithFormat:@"%lu", (unsigned long)[self.model.dependencies count]];
    NSString *dependants = [NSString stringWithFormat:@"%lu", (unsigned long)[self.model.dependants count]];

    self.titleLabel.text        = title;
    self.timeFrameLabel.text    = timeFrame;
    self.locationsLabel.text    = locations;
    self.dependantsLabel.text   = dependants;
    self.dependenciesLabel.text = dependencies;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([@"Edit Task" isEqualToString:segue.identifier]) {
		TVC_EditTask *controller = segue.destinationViewController;
		controller.model = self.model;
    }
}

@end
