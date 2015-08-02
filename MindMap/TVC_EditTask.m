#import "TVC_EditTask.h"

#import "NSDate+Friendly.h"

#import "TVC_ListDependencies.h"
#import "TVC_ListDependants.h"
#import "TVC_EditTimeFrame.h"

#import "Task+Business.h"
#import "Place+Business.h"
#import "TimeFrame+Business.h"

#define SEGUE_LISTDEPENDENCIES @"List Dependencies"
#define SEGUE_LISTDEPENDANTS @"List Dependants"
#define SEGUE_EDITTIMEFRAME @"Edit TimeFrame"

@interface TVC_EditTask() <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *titleTextField;
@property (nonatomic, weak) IBOutlet UILabel *timeFrameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationsLabel;
@property (nonatomic, weak) IBOutlet UILabel *dependenciesLabel;
@property (nonatomic, weak) IBOutlet UILabel *dependantsLabel;

@end

@implementation TVC_EditTask

#pragma mark - Properties

- (Task *)task {
	return (Task *)self.managedObject;
}

- (void)setTask:(Task *)task {
	if (self.managedObject != task) {
		self.managedObject = task;
	}
}

#pragma mark - Bindings

- (BOOL)bindToModel:(NSError **)error {
    NSString *title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    self.task.title = title;

	return [super bindToModel:error];
}

- (void)bindToView {
    NSString *title			= self.task.title;
    NSString *timeFrame		= [NSDate describeDateFrom:self.task.enforcedStartDate to:self.task.enforcedEndDate];
    NSString *locations		= @""; //TODO Location
    NSString *dependencies	= [NSString stringWithFormat:@"%lu", (unsigned long)[self.task.dependencies count]];
    NSString *dependants	= [NSString stringWithFormat:@"%lu", (unsigned long)[self.task.dependants count]];

    self.titleTextField.text    = title;
    self.timeFrameLabel.text    = timeFrame;
    self.locationsLabel.text    = locations;
    self.dependantsLabel.text   = dependants;
    self.dependenciesLabel.text = dependencies;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([SEGUE_LISTDEPENDENCIES isEqualToString:segue.identifier]) {
		TVC_ListDependencies *controller = segue.destinationViewController;
		controller.model = self.task;
		controller.navigationItem.title = self.task.title;
	} else 	if ([SEGUE_LISTDEPENDANTS isEqualToString:segue.identifier]) {
		TVC_ListDependants *controller = segue.destinationViewController;
		controller.model = self.task;
		controller.navigationItem.title = self.task.title;
	} else 	if ([SEGUE_EDITTIMEFRAME isEqualToString:segue.identifier]) {
		TVC_EditTimeFrame *controller = segue.destinationViewController;
		controller.task = self.task;
	}
}

@end
