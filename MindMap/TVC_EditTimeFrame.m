#import "TVC_EditTimeFrame.h"

#import "TimeFrame+Business.h"

@interface TVC_EditTimeFrame()

@property (weak, nonatomic) IBOutlet UISwitch *startDateSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;

@property (weak, nonatomic) IBOutlet UISwitch *endDateSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@end

@implementation TVC_EditTimeFrame

#pragma mark - Properties

- (Task *)task {
	return (Task *)self.managedObject;
}

- (void)setTask:(Task *)task {
	if (self.managedObject != task) {
		self.managedObject = task;
	}
}

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (![self.task.enforcedStartDate isEqualToDate:self.task.timeFrame.startDate]) {
		self.startDateSwitch.on = YES;
		self.startDateSwitch.enabled = NO;
	}
	if (![self.task.enforcedEndDate isEqualToDate:self.task.timeFrame.endDate]) {
		self.endDateSwitch.on = YES;
		self.endDateSwitch.enabled = NO;
	}
}

#pragma mark - UIDatePickerTarget

- (IBAction)startDateChanged:(UIDatePicker *)sender {
	NSDate *startDate	= sender.date;
	NSDate *minimumEndDate = self.task.enforcedStartDate;
	
	if ([minimumEndDate compare:startDate] == NSOrderedAscending) {
		minimumEndDate = startDate;
	}
	
	self.endDatePicker.minimumDate = minimumEndDate;
}

- (IBAction)endDateChanged:(UIDatePicker *)sender {
	NSDate *endDate		= sender.date;
	NSDate *maximumStartDate = self.task.enforcedEndDate;
	
	if ([maximumStartDate compare:endDate] == NSOrderedDescending) {
		maximumStartDate = endDate;
	}
	
	self.startDatePicker.maximumDate = maximumStartDate;
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
	NSDate *startDate	= self.task.timeFrame.startDate;
	NSDate *endDate		= self.task.timeFrame.endDate;

	NSDate *minimumStartDate = self.task.enforcedStartDate;
	NSDate *maximumStartDate = self.task.enforcedEndDate;
	NSDate *minimumEndDate = self.task.enforcedStartDate;
	NSDate *maximumEndDate = self.task.enforcedEndDate;

	if ([maximumStartDate compare:endDate] == NSOrderedDescending) {
		maximumStartDate = endDate;
	}

	if ([minimumEndDate compare:startDate] == NSOrderedAscending) {
		minimumEndDate = startDate;
	}

	self.startDatePicker.minimumDate	= minimumStartDate;
	self.startDatePicker.maximumDate	= maximumStartDate;
	self.endDatePicker.minimumDate		= minimumEndDate;
	self.endDatePicker.maximumDate		= maximumEndDate;

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

	self.task.timeFrame.startDate	= startDate;
	self.task.timeFrame.endDate		= endDate;

	return [super bindToModel:error]; //todo remove this and revert on cancel (it's show for now, could/should be modal
}

#pragma mark - Actions

- (IBAction)doneAction:(id)sender {
	NSError *error;

	[self bindToModel:&error];

	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateSwitches:(UISwitch *)sender {
	if ([sender isEqual:self.startDateSwitch]) {
		if (!sender.on) {
			self.task.timeFrame.startDate = [NSDate distantPast];
		}
	} else if ([sender isEqual:self.endDateSwitch]) {
		if (!sender.on) {
			self.task.timeFrame.endDate = [NSDate distantFuture];
		}
	}

	[self.tableView reloadData];
}

@end
