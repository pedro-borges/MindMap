//
//  TVC_ListHierarchy.m
//  MindMap
//
//  Created by Pedro Borges on 03/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_ListHierarchy.h"

@interface TVC_ListHierarchy ()

@end

@implementation TVC_ListHierarchy

#pragma mark - Properties

@synthesize model = _model;

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return YES;
        case 1: return NO;
    }
    
    return NO;
}

@end
