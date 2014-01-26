//
//  HRRecipeParser.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRRecipeParser.h"

@implementation HRRecipeParser

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity
{
    if ([representation isEqual:[NSNull null]]) {
        return nil;
    }
    
    NSMutableDictionary *mutableAttributes = [[super attributesForRepresentation:representation ofEntity:entity] mutableCopy];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *difficulty = [mutableAttributes objectForKey:@"difficulty"];
    [mutableAttributes setObject:[numberFormatter numberFromString:difficulty] forKey:@"difficulty"];
    
    NSString *referenceID = [representation objectForKey:@"id"];
    if (referenceID) {
        [mutableAttributes setObject:referenceID forKey:@"referenceID"];
    }
    
    NSString *photoUrlString = [[mutableAttributes objectForKey:@"photo"] objectForKey:@"url"];
    
#warning PUT INTO THREAD!
    if (![photoUrlString isEqual:[NSNull null]]) {
//        NSURL *photoUrl = [NSURL URLWithString:photoUrlString];
//        NSData *data = [NSData dataWithContentsOfURL:photoUrl];
//        UIImage *photoImage = [[UIImage alloc] initWithData:data];
//        [mutableAttributes setObject:photoImage forKey:@"photo"];
        [mutableAttributes removeObjectForKey:@"photo"];
    } else {
        [mutableAttributes removeObjectForKey:@"photo"];
    }
    
    return mutableAttributes;
}

- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes;
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];
    
    [mutableAttributes removeObjectForKey:@"photo"];
    [mutableAttributes removeObjectForKey:@"overview"];
    [mutableAttributes removeObjectForKey:@"referenceID"];
    
    return @{@"recipe":mutableAttributes};
}

@end
