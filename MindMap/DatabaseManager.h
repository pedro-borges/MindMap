#import <UIKit/UIKit.h>

#import "TVC_List_CoreData.h"

@interface DatabaseManager : NSObject

@property (nonatomic, strong) UIManagedDocument *document;

+ (DatabaseManager *)defaultManagerForController:(TVC_List_CoreData *)controller;
+ (DatabaseManager *)defaultManager;

@end
