#import "TVC_List_Array.h"

@interface TVC_List_Array ()

- (void)bindToView;

@end

@implementation TVC_List_Array

@synthesize list = _list;

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self bindToView];
}

#pragma mark - Abstract

- (void)bindToView {
    @throw [NSException exceptionWithName:@"Abstraction violation" reason:@"Direct call to [TVC_List_Array bindToView]" userInfo:nil];
}

@end
