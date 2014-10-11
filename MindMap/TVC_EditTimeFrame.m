//
//  TVC_EditTimeFrame.m
//  MindMap
//
//  Created by Pedro Borges on 10/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_EditTimeFrame.h"

@interface TVC_EditTimeFrame() <UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *startDateSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;

@property (weak, nonatomic) IBOutlet UISwitch *endDateSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@end

@implementation TVC_EditTimeFrame

#pragma mark - Properties

- (TimeFrame *)timeFrame {
	return (TimeFrame *)self.managedObject;
}

- (void)setTimeFrame:(TimeFrame *)timeFrame {
	if (self.managedObject != timeFrame) {
		self.managedObject = timeFrame;
		
		[self bindToView];
	}
}

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = [super tableView:tableView numberOfRowsInSection:section];

	switch (section) {
		case 0:
			if (self.startDateSwitch.on) {
				return result;
			} else {
				return result - 1;
			}
		case 1:
			if (self.endDateSwitch.on) {
				return result;
			} else {
				return result - 1;
			}
			break;
	}
	
	return result;
}

#pragma mark - Bindings

- (void)bindToView {
	NSDate *startDate	= self.timeFrame.startDate;
	NSDate *endDate		= self.timeFrame.endDate;

	NSLog(@"startDate = %@", startDate);
	NSLog(@"endDate = %@", endDate);

	if ((startDate == nil) || [startDate isEqualToDate:[NSDate distantPast]]) {
		// Start date - OFF
		self.startDateSwitch.on = NO;
		self.startDatePicker.date = [NSDate date];
	} else {
		// Start date - ON
		self.startDateSwitch.on = YES;
		self.startDatePicker.date = startDate;
	}

	if ((endDate == nil) || [endDate isEqualToDate:[NSDate distantFuture]]) {
		self.endDateSwitch.on = NO;
		self.endDatePicker.date = [NSDate date];
	} else {
		self.endDateSwitch.on = YES;
		self.endDatePicker.date = endDate;
	}
}

- (BOOL)bindToModel:(NSError **)error {
	NSDate *startDate	= self.startDateSwitch.on ? self.startDatePicker.date : [NSDate distantPast];
	NSDate *endDate		= self.endDateSwitch.on ? self.endDatePicker.date : [NSDate distantFuture];

	self.timeFrame.startDate	= startDate;
	self.timeFrame.endDate		= endDate;

	return YES;
}

#pragma mark - UIPickerViewDelegate

- (IBAction)doneAction:(id)sender {
	NSError *error;

	[self bindToModel:&error];

	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)updateSwitches:(UISwitch *)sender {
	if ([sender isEqual:self.startDateSwitch]) {
		if (!sender.on) {
			self.timeFrame.startDate = [NSDate distantPast];
		}
	} else if ([sender isEqual:self.endDateSwitch]) {
		if (!sender.on) {
			self.timeFrame.endDate = [NSDate distantFuture];
		}
	}

	[self.tableView reloadData];
}

@end
