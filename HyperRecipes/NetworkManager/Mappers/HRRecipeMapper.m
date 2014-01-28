//
//  HRRecipeParser.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRRecipeMapper.h"

@implementation HRRecipeMapper

- (void)attributesForRepresentation:(NSDictionary *)representation
                           ofEntity:(NSEntityDescription *)entity
              withCompletionHandler:(void (^)(NSDictionary *dictionary))completion;
{
    if (!completion) {
        return;
    }
    
    [super attributesForRepresentation:representation ofEntity:entity withCompletionHandler:^(NSDictionary *dictionary) {
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableDictionary *mutableAttributes = [dictionary mutableCopy];
            
            NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSString *difficulty = [mutableAttributes objectForKey:@"difficulty"];
            [mutableAttributes setObject:[numberFormatter numberFromString:difficulty] forKey:@"difficulty"];
            
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(mutableAttributes);
            });
        });
    }];
}

- (void)representationOfAttributes:(NSDictionary *)attributes
             withCompletionHandler:(void (^)(NSDictionary *dictionary))completion
{
    if (!completion) {
        return;
    }
    
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];
    
    [mutableAttributes setObject:mutableAttributes[@"overview"] forKey:@"description"];
    
    [mutableAttributes removeObjectForKey:@"photo"];
    [mutableAttributes removeObjectForKey:@"overview"];
    [mutableAttributes removeObjectForKey:@"referenceID"];
    
    completion(@{@"recipe":mutableAttributes});
}

@end
