//
//  VC_Root.h
//  MindMap
//
//  Created by Pedro Borges on 07/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TVC_List_CoreData.h"

@interface DatabaseManager : NSObject

@property (nonatomic, strong) UIManagedDocument *document;

+ (DatabaseManager *)defaultManagerForController:(TVC_List_CoreData *)controller;
+ (DatabaseManager *)defaultManager;

@end
