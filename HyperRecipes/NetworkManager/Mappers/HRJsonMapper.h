//
//  HRJsonParser.h
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

@interface HRJsonMapper : NSObject

- (void)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
                        withCompletionHandler:(void (^)(NSDictionary *dictionary))completion;

- (void)representationOfAttributes:(NSDictionary *)attributes
                       withCompletionHandler:(void (^)(NSDictionary *dictionary))completion;

@end
