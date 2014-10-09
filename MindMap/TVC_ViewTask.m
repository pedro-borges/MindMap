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

- (Task *)task {
	return (Task *)self.managedObject;
}

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	[self bindToView];
}

#pragma mark - Overrides

- (void)setTask:(Task *)model {
    if (self.managedObject != model) {
        self.managedObject = model;
    }
}

- (void)bindToView {
    NSString *title = self.task.title;
    NSString *timeFrame = self.task.timeFrame.description;
    NSString *locations = @""; //TODO Location
    NSString *dependencies = [NSString stringWithFormat:@"%lu", (unsigned long)[self.task.dependencies count]];
    NSString *dependants = [NSString stringWithFormat:@"%lu", (unsigned long)[self.task.dependants count]];

    self.titleLabel.text        = title;
    self.timeFrameLabel.text    = timeFrame;
    self.locationsLabel.text    = locations;
    self.dependantsLabel.text   = dependants;
    self.dependenciesLabel.text = dependencies;
}

@end
