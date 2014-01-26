//
//  HRRecipeDetailViewController.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/23/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRRecipeDetailViewController.h"
#import "HRRecipeEditViewController.h"
#import "HRRecipe.h"

@interface HRRecipeDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation HRRecipeDetailViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.difficultyLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"DIFFICULITY", nil)];
    self.favoriteLabel.text = NSLocalizedString(@"FAVORITE", nil);
    self.descriptionLabel.text = NSLocalizedString(@"DESCRIPTION", nil);
    self.instructionsLabel.text = NSLocalizedString(@"INSTRUCTIONS", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditRecipeButtonTapped:)];
    
    [self updateUi];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUi];
}

#pragma mark - Public

- (void)setRecipe:(HRRecipe *)recipe
{
    _recipe = recipe;
    
    [self updateUi];
}

#pragma mark - IBAction

- (void)onEditRecipeButtonTapped:(id)sender
{
    HRRecipeEditViewController *recipeAddViewController = [HRRecipeEditViewController new];
    recipeAddViewController.managedObjectContext = self.managedObjectContext;
    recipeAddViewController.recipe = self.recipe;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:recipeAddViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private

- (void)updateUi
{
    if (!self.recipe) {
        return;
    }
    
    self.nameValueLabel.text = self.recipe.name;
    self.difficultyValueLabel.text = [HRRecipe localizedStringLabelForDifficulty:[self.recipe.difficulty intValue]];
    [self.favoriteLabel setHidden:![self.recipe.favorite boolValue]];
    self.descriptionValueLabel.text = self.recipe.overview;
    self.instructionsValueLabel.text = self.recipe.instructions;
    self.photoImageView.image = self.recipe.photo;
}

@end
