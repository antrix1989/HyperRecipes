//
//  HRNetworkManager.h
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

@class HRRecipe;

@interface HRNetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)synchronizeDbInContect:(NSManagedObjectContext *)managedObjectContext withCompletionHandler:(void (^)(BOOL success))completion;

- (void)createRecipe:(HRRecipe *)recipe
         withContext:(NSManagedObjectContext *)managedObjectContext
withCompletionHandler:(void (^)(BOOL success, NSDictionary* attributes))completion;

- (void)updateRecipe:(HRRecipe *)recipe withCompletionHandler:(void (^)(BOOL success))completion;

- (void)deleteRecipe:(HRRecipe *)recipe withCompletionHandler:(void (^)(BOOL success))completion;

@end
