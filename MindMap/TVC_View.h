#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TVC_View : UITableViewController

@property (nonatomic, strong) NSManagedObject *managedObject;

- (void)bindToView;

@end
