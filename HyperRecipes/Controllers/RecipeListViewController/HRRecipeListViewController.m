//
//  HRRecipeListViewController.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/21/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRRecipeListViewController.h"
#import "HRRecipeEditViewController.h"
#import "HRRecipeDetailViewController.h"
#import "Recipe.h"

@interface HRRecipeListViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HRRecipeListViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Recipes", nil);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    fetchRequest.returnsObjectsAsFaults = NO;
    fetchRequest.includesPendingChanges = NO;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddRecipeButtonTapped:)];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

#pragma mark - IBAction

- (void)onAddRecipeButtonTapped:(id)sender
{
    HRRecipeEditViewController *recipeAddViewController = [HRRecipeEditViewController new];
    recipeAddViewController.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:recipeAddViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Recipe *recipe = (Recipe *)[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[recipe name] description];
    cell.imageView.image = recipe.photo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path.
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		}
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Recipe *recipe = (Recipe *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    HRRecipeDetailViewController *recipeDetailViewController = [HRRecipeDetailViewController new];
    recipeDetailViewController.managedObjectContext = self.managedObjectContext;
    recipeDetailViewController.recipe = recipe;
    
    [self.navigationController pushViewController:recipeDetailViewController animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}


@end
