#import "TBC_ManageProject.h"

#import "TVC_ListTasks.h"

#import "Settings.h"

@implementation TBC_ManageProject

#pragma mark - Properties

#pragma mark - UIKit

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.selectedIndex = 1;
}

@end
