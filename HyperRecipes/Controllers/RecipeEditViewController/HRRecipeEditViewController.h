//
//  HRRecipeAddViewController.h
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/23/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

@class HRRecipe;

@interface HRRecipeEditViewController : UIViewController

@property (strong, nonatomic) HRRecipe *recipe;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
