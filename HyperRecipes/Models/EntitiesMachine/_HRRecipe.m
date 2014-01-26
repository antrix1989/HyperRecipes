// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HRRecipe.m instead.

#import "_HRRecipe.h"

const struct HRRecipeAttributes HRRecipeAttributes = {
	.difficulty = @"difficulty",
	.favorite = @"favorite",
	.instructions = @"instructions",
	.name = @"name",
	.overview = @"overview",
	.photo = @"photo",
	.referenceID = @"referenceID",
};

const struct HRRecipeRelationships HRRecipeRelationships = {
};

const struct HRRecipeFetchedProperties HRRecipeFetchedProperties = {
};

@implementation HRRecipeID
@end

@implementation _HRRecipe

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HRRecipe" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HRRecipe";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HRRecipe" inManagedObjectContext:moc_];
}

- (HRRecipeID*)objectID {
	return (HRRecipeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"difficultyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"difficulty"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"favoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"referenceIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"referenceID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic difficulty;



- (int16_t)difficultyValue {
	NSNumber *result = [self difficulty];
	return [result shortValue];
}

- (void)setDifficultyValue:(int16_t)value_ {
	[self setDifficulty:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveDifficultyValue {
	NSNumber *result = [self primitiveDifficulty];
	return [result shortValue];
}

- (void)setPrimitiveDifficultyValue:(int16_t)value_ {
	[self setPrimitiveDifficulty:[NSNumber numberWithShort:value_]];
}





@dynamic favorite;



- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}

- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFavoriteValue {
	NSNumber *result = [self primitiveFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFavorite:[NSNumber numberWithBool:value_]];
}





@dynamic instructions;






@dynamic name;






@dynamic overview;






@dynamic photo;






@dynamic referenceID;



- (int16_t)referenceIDValue {
	NSNumber *result = [self referenceID];
	return [result shortValue];
}

- (void)setReferenceIDValue:(int16_t)value_ {
	[self setReferenceID:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveReferenceIDValue {
	NSNumber *result = [self primitiveReferenceID];
	return [result shortValue];
}

- (void)setPrimitiveReferenceIDValue:(int16_t)value_ {
	[self setPrimitiveReferenceID:[NSNumber numberWithShort:value_]];
}










@end
