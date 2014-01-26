#import "_Recipe.h"

@interface Recipe : _Recipe {}

- (id)initWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
