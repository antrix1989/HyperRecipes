//
//  HRJsonParser.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRJsonMapper.h"

@implementation HRJsonMapper

- (void)attributesForRepresentation:(NSDictionary *)representation
                           ofEntity:(NSEntityDescription *)entity
              withCompletionHandler:(void (^)(NSDictionary *dictionary))completion;
{
    if (!completion) {
        return;
    }
    
    if ([representation isEqual:[NSNull null]]) {
        completion(nil);
        return;
    }
    
    NSMutableDictionary *mutableAttributes = [representation mutableCopy];
    
    @autoreleasepool {
        NSMutableSet *mutableKeys = [NSMutableSet setWithArray:[representation allKeys]];
        [mutableKeys minusSet:[NSSet setWithArray:[[entity attributesByName] allKeys]]];
        [mutableAttributes removeObjectsForKeys:[mutableKeys allObjects]];
    }
    
    completion(mutableAttributes);
}

- (void)representationOfAttributes:(NSDictionary *)attributes
             withCompletionHandler:(void (^)(NSDictionary *dictionary))completion;
{
    if (completion) {
        completion(attributes);
    }
}

@end
