//
//  HRJsonParser.h
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

@interface HRJsonParser : NSObject

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity;

- (NSDictionary *)representationOfAttributes:(NSDictionary *)attributes;

@end
