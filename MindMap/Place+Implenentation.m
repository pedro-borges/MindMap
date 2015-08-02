#import "Place+Implenentation.h"
#import "Database.h"

@implementation Place (Implenentation)

+ (Place *)createFromContext:(NSManagedObjectContext *)context
                        nsme:(NSString *)name
                    location:(NSData *)location
                      radius:(NSNumber *)radius {
    Place *result;
    
    result = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
    
    result.name     = name;
    result.location = location;
    result.radius   = radius;
    
    [Database saveManagedObjectByForce:result];
    
    return result;
}

@end
