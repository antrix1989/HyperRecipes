//
//  HRRecipeParser.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRRecipeMapper.h"

@implementation HRRecipeMapper

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity
{
    NSDictionary *dictionary = [super attributesForRepresentation:representation ofEntity:entity];
    
    NSMutableDictionary *mutableAttributes = [dictionary mutableCopy];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *difficulty = [mutableAttributes objectForKey:@"difficulty"];
    [mutableAttributes setObject:[numberFormatter numberFromString:difficulty] forKey:@"difficulty"];
    
    NSString *description = [representation objectForKey:@"description"];
    [mutableAttributes setObject:description forKey:@"overview"];
    
    NSString *referenceID = [representation objectForKey:@"id"];
    if (referenceID) {
        [mutableAttributes setObject:referenceID forKey:@"referenceID"];
    }
    
    NSString *photoUrlString = [[mutableAttributes objectForKey:@"photo"] objectForKey:@"url"];
    
    if (![photoUrlString isEqual:[NSNull null]]) {
        NSURL *photoUrl = [NSURL URLWithString:photoUrlString];
        NSData *data = [NSData dataWithContentsOfURL:photoUrl];
        UIImage *photoImage = [[UIImage alloc] initWithData:data];
        
        [mutableAttributes setObject:photoImage forKey:@"photo"];
    } else {
        [mutableAttributes removeObjectForKey:@"photo"];
    }

    return mutableAttributes;
}

- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];
    
    [mutableAttributes setObject:mutableAttributes[@"overview"] forKey:@"description"];
    
    [mutableAttributes removeObjectForKey:@"photo"];
    [mutableAttributes removeObjectForKey:@"overview"];
    [mutableAttributes removeObjectForKey:@"referenceID"];
    
    return @{@"recipe":mutableAttributes};
}

@end
