//
//  NC_Root.m
//  MindMap
//
//  Created by Pedro Borges on 05/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "NC_Root.h"

#import "TVC_ListProjects.h"

#import <CoreData/CoreData.h>

@implementation NC_Root

#pragma mark - Properties

@synthesize document = _document;

#pragma mark - UIKit

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!self.document) {
        NSURL *url = [self iCloudDocumentsURL];
        
        if ([[NSFileManager defaultManager] ubiquityIdentityToken] == nil) {
            NSLog(@"iCloud is OFF");
        }
        
        url = [url URLByAppendingPathComponent:@"mindmap_database"];
        
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
    TVC_ListProjects *controller = (TVC_ListProjects *)[self topViewController];

    controller.context = self.document.managedObjectContext;
}

#pragma mark - Notifications

- (void)documentChanged:(NSNotification *)notification {
    [self.document.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

- (void)documentStateChanged:(NSNotification *)notification {
    if (self.document.documentState == UIDocumentStateNormal) {
        NSLog(@"Document.state = NORMAL");
    } else if (self.document.documentState & UIDocumentStateInConflict) {
        NSLog(@"Document.state = CONFLICT *************");
    } else if (self.document.documentState & UIDocumentStateSavingError) {
        NSLog(@"Document.state = SAVING ERROR *************");
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (NSURL *)iCloudURL {
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}

- (NSURL *)iCloudDocumentsURL {
    return [[self iCloudURL] URLByAppendingPathComponent:@"Documents"];
}

- (NSURL *)iCloudCoreDataLogFileURL {
    return [[self iCloudURL] URLByAppendingPathComponent:@"Logs"];
}

- (void)setPersistentStoreOptionsInDocument:(UIManagedDocument *)document {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    NSString *name = [document.fileURL lastPathComponent];
    NSURL *logsURL = [self iCloudCoreDataLogFileURL];
    
    [options setObject:name forKey:NSPersistentStoreUbiquitousContentNameKey];
    [options setObject:logsURL forKey:NSPersistentStoreUbiquitousContentURLKey];
    
    document.persistentStoreOptions = options;
}

- (void)setDocument:(UIManagedDocument *)document {
    if(_document != document) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                      object:_document.managedObjectContext.persistentStoreCoordinator];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIDocumentStateChangedNotification
                                                      object:_document];
        _document = document;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentChanged:)
                                                     name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                   object:document.managedObjectContext.persistentStoreCoordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentStateChanged:)
                                                     name:UIDocumentStateChangedNotification
                                                   object:document];
        
        [self useDocument];
    }
}

- (void)useDocument {
    [self setPersistentStoreOptionsInDocument:self.document];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        }];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
        }];
    } else if (self.document.documentState == UIDocumentStateNormal) {

    }
}

@end
