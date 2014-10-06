//
//  TVC.h
//  MindMap
//
//  Created by Pedro Borges on 02/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TVC_View : UITableViewController

@property (nonatomic, strong) NSManagedObject *managedObject;

- (void)bindToView;

@end
