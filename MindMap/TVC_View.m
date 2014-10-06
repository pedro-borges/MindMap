//
//  TVC.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_View.h"

@implementation TVC_View

@synthesize managedObject;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)bindToView {
    @throw [NSException exceptionWithName:@"Abstraction violation"
                                   reason:@"bindToView not implemented in superclass"
                                 userInfo:nil];
}

@end
