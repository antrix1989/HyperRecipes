//
//  Recipe.h
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/23/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ImageToDataTransformer : NSValueTransformer
@end

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) id photo;

- (id)initWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
