#import "Recipe.h"

@interface Recipe ()

@end

@implementation Recipe

- (id)initWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [self initWithEntity:[NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:context] insertIntoManagedObjectContext:nil];
    if (!self) {
        return nil;
    }
    
    self.name = name;
    self.difficulty = @(1);
    
    return self;
}


@end
