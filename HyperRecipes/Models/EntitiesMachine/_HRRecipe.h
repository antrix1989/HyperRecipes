// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HRRecipe.h instead.

#import <CoreData/CoreData.h>


extern const struct HRRecipeAttributes {
	__unsafe_unretained NSString *difficulty;
	__unsafe_unretained NSString *favorite;
	__unsafe_unretained NSString *instructions;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *overview;
	__unsafe_unretained NSString *photo;
	__unsafe_unretained NSString *referenceID;
} HRRecipeAttributes;

extern const struct HRRecipeRelationships {
} HRRecipeRelationships;

extern const struct HRRecipeFetchedProperties {
} HRRecipeFetchedProperties;







@class UIImage;


@interface HRRecipeID : NSManagedObjectID {}
@end

@interface _HRRecipe : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HRRecipeID*)objectID;





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





@property (nonatomic, strong) NSNumber* referenceID;



@property int16_t referenceIDValue;
- (int16_t)referenceIDValue;
- (void)setReferenceIDValue:(int16_t)value_;

//- (BOOL)validateReferenceID:(id*)value_ error:(NSError**)error_;






@end

@interface _HRRecipe (CoreDataGeneratedAccessors)

@end

@interface _HRRecipe (CoreDataGeneratedPrimitiveAccessors)


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




- (NSNumber*)primitiveReferenceID;
- (void)setPrimitiveReferenceID:(NSNumber*)value;

- (int16_t)primitiveReferenceIDValue;
- (void)setPrimitiveReferenceIDValue:(int16_t)value_;




@end
