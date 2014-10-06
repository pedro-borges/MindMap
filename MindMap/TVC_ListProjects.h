//
//  TVC_ListProjects.h
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "TVC_List_CoreData.h"

#import "Project+Business.h"

@interface TVC_ListProjects : TVC_List_CoreData

@property (nonatomic, readonly) Project *selectedProject;

@end
