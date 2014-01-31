//
//  HRJsonParser.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRJsonMapper.h"

@implementation HRJsonMapper

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity;
{
    if ([representation isEqual:[NSNull null]]) {
        return nil;
    }
    
    NSMutableDictionary *mutableAttributes = [representation mutableCopy];
    
    NSMutableSet *mutableKeys = [NSMutableSet setWithArray:[representation allKeys]];
    [mutableKeys minusSet:[NSSet setWithArray:[[entity attributesByName] allKeys]]];
    [mutableAttributes removeObjectsForKeys:[mutableKeys allObjects]];
    
    return mutableAttributes;
}

- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes;
{
    return attributes;
}

@end
