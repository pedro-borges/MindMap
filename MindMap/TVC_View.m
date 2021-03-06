#import "TVC_View.h"

#import "TVC_Edit.h"

#define SEGUE_EDIT @"Edit"

@implementation TVC_View

#pragma mark - Properties

@synthesize managedObject;

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self bindToView];
}

#pragma mark - Bindings

- (void)bindToView {
    @throw [NSException exceptionWithName:@"Abstraction violation"
                                   reason:@"bindToView not implemented in superclass"
                                 userInfo:nil];
}

@end
