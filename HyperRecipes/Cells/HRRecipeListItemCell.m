//
//  HRRecipeListItemCell.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/29/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRRecipeListItemCell.h"
#import "HRRecipe.h"

@interface HRRecipeListItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HRRecipeListItemCell

#pragma mark - Public

- (void)setRecipe:(HRRecipe *)recipe
{
    _recipe = recipe;
    
    self.photoImageView.image = recipe.photo;
    self.titleLabel.text = recipe.name;
}

@end
