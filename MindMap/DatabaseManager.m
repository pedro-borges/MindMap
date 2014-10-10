//
//  VC_Root.m
//  MindMap
//
//  Created by Pedro Borges on 07/10/14.
//  Copyright (c) 2014 PCB. All rights reserved.
//

#import "DatabaseManager.h"

#import "TVC_ListProjects.h"

#import <CoreData/CoreData.h>

#define DATABASE_DEFAULT @"mindmap_database"

#define SEGUE_INITIALIZE @"Initialize"

@interface DatabaseManager()

@property (nonatomic, readonly) TVC_List_CoreData *rootController;
@property (nonatomic, readonly) BOOL ready;

@end

@implementation DatabaseManager

#pragma mark - Properties

static DatabaseManager *_defaultManager;

@synthesize ready = _ready;

+ (DatabaseManager *)defaultManager {
	return _defaultManager;
}

+ (DatabaseManager *)defaultManagerForController:(TVC_List_CoreData *)controller {
    if(_defaultManager == nil) {
        _defaultManager = [[DatabaseManager alloc] initWithName:DATABASE_DEFAULT andRootController:controller];
    }
    
    return _defaultManager;
}

@synthesize rootController = _rootController;
@synthesize document = _document;

- (id)initWithName:(NSString *)name andRootController:(TVC_List_CoreData *)controller {
    self = [super init];

    if (self) {
        _rootController = controller;
        
        if(!self.document) {
            NSURL *url = [self iCloudDocumentsURL];
            
            if ([[NSFileManager defaultManager] ubiquityIdentityToken] == nil) {
                NSLog(@"iCloud is OFF");
            }
            
            url = [url URLByAppendingPathComponent:name];
            
            self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        }
    }
    
    return self;
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

- (void)setupFetchedResultsController {
    [self.rootController bindToView];
}

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
	
	NSLog(@"Refresh Controller: %@", self.rootController);
	
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
			NSLog(@"Create document = %i", success);
			self.rootController.context = nil;
            [self.rootController bindToView];
        }];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
			NSLog(@"Open document = %i", success);
			self.rootController.context = nil;
            [self.rootController bindToView];
        }];
    } else if (self.document.documentState == UIDocumentStateNormal) {
		NSLog(@"document = normal");
		self.rootController.context = nil;
		[self.rootController bindToView];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([SEGUE_INITIALIZE isEqualToString:segue.identifier]) {
        UINavigationController *navigationController = segue.destinationViewController;
        
        TVC_ListProjects *controller = (TVC_ListProjects *)[navigationController topViewController];
        
        controller.context = self.document.managedObjectContext;
    }
}

@end
