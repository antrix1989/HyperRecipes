#import "_HRRecipe.h"

@interface HRRecipe : _HRRecipe

- (id)initWithName:(NSString *)name andDifficulty:(NSNumber *)difficulty inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSString *)localizedStringLabelForDifficulty:(int)difficulty;

@end
