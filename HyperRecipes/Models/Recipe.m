//
//  Recipe.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/23/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "Recipe.h"


@implementation Recipe

@dynamic difficulty;
@dynamic favorite;
@dynamic instructions;
@dynamic name;
@dynamic overview;
@dynamic photo;

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

@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

+ (Class)transformedValueClass
{
	return [NSData class];
}


- (id)transformedValue:(id)value
{
	return UIImagePNGRepresentation(value);
}


- (id)reverseTransformedValue:(id)value
{
	return [[UIImage alloc] initWithData:value];
}

@end