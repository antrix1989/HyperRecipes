// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipe.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipeAttributes {
	__unsafe_unretained NSString *difficulty;
	__unsafe_unretained NSString *favorite;
	__unsafe_unretained NSString *instructions;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *overview;
	__unsafe_unretained NSString *photo;
} RecipeAttributes;

extern const struct RecipeRelationships {
} RecipeRelationships;

extern const struct RecipeFetchedProperties {
} RecipeFetchedProperties;







@class UIImage;

@interface RecipeID : NSManagedObjectID {}
@end

@interface _Recipe : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecipeID*)objectID;





@property (nonatomic, strong) NSNumber* difficulty;



@property int16_t difficultyValue;
- (int16_t)difficultyValue;
- (void)setDifficultyValue:(int16_t)value_;

//- (BOOL)validateDifficulty:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* favorite;



@property BOOL favoriteValue;
- (BOOL)favoriteValue;
- (void)setFavoriteValue:(BOOL)value_;

//- (BOOL)validateFavorite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* instructions;



//- (BOOL)validateInstructions:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* overview;



//- (BOOL)validateOverview:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) UIImage* photo;



//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;






@end

@interface _Recipe (CoreDataGeneratedAccessors)

@end

@interface _Recipe (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDifficulty;
- (void)setPrimitiveDifficulty:(NSNumber*)value;

- (int16_t)primitiveDifficultyValue;
- (void)setPrimitiveDifficultyValue:(int16_t)value_;




- (NSNumber*)primitiveFavorite;
- (void)setPrimitiveFavorite:(NSNumber*)value;

- (BOOL)primitiveFavoriteValue;
- (void)setPrimitiveFavoriteValue:(BOOL)value_;




- (NSString*)primitiveInstructions;
- (void)setPrimitiveInstructions:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveOverview;
- (void)setPrimitiveOverview:(NSString*)value;




- (UIImage*)primitivePhoto;
- (void)setPrimitivePhoto:(UIImage*)value;




@end
