//
//  TVC_ListTasksPast.m
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListTasksPast.h"

@implementation TVC_ListTasksPast

#pragma mark - UIKit

- (void)viewWillAppear:(BOOL)animated {
	self.predicate = [NSPredicate predicateWithFormat:@"(project = %@) AND (completion != nil)", self.project];

	[super viewWillAppear:animated];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];
}

@end
