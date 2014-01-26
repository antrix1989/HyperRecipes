#import "HRRecipe.h"

@interface HRRecipe ()

@end

@implementation HRRecipe

#pragma mark - Public

- (id)initWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
#warning check.
    self = [self initWithEntity:[NSEntityDescription entityForName:@"HRRecipe" inManagedObjectContext:context] insertIntoManagedObjectContext:nil];
    if (!self) {
        return nil;
    }
    
    self.name = name;
    self.difficulty = @(1);
    
    return self;
}

+ (NSString *)localizedStringLabelForDifficulty:(int)difficulty
{
    switch (difficulty) {
        case 1:
            return NSLocalizedString(@"Easy", nil);
        case 2:
            return NSLocalizedString(@"Medium", nil);
        case 3:
            return NSLocalizedString(@"Hard", nil);
        default:
            return nil;
    }
}

@end
