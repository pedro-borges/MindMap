#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

@property BOOL debug;

@end