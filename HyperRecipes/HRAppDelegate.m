//
//  HRAppDelegate.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/21/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRAppDelegate.h"
#import "HRRecipeListViewController.h"
#import "HRNetworkManager.h"
#import "HRSynchronizationView.h"

static NSString *kDBName = @"HyperRecipes";

@interface HRAppDelegate ()

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) HRSynchronizationView *synchronizationView;

@end

@implementation HRAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HRRecipeListViewController *recipeListViewController = [HRRecipeListViewController new];
    recipeListViewController.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:recipeListViewController];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    [self showSynchronizationView];
    
    NSLog(@"Synchronization...");
    [[HRNetworkManager sharedInstance] synchronizeDbInContext:self.managedObjectContext withCompletionHandler:^(BOOL success) {
        [self hideSynchronizationView];
        
        if (success) {
            NSLog(@"Synchronization is done.");
        } else {
            NSLog(@"Synchronization is failed.");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notice!", nil)
                                                            message:NSLocalizedString(@"Synchronization is failed.", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }];
    
    return YES;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{   
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        [_managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    }
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDBName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kDBName]];
    
    NSDictionary *options = @{
                              NSInferMappingModelAutomaticallyOption : @(YES),
                              NSMigratePersistentStoresAutomaticallyOption: @(YES)
                              };
    
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kDBName]];
    
    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Private

- (void)showSynchronizationView
{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"HRSynchronizationView" owner:self options:nil];
    self.synchronizationView = (HRSynchronizationView *)[nibObjects objectAtIndex:0];
    self.synchronizationView.frame = self.window.rootViewController.view.bounds;
    [self.synchronizationView setCenter:self.window.rootViewController.view.center];
    [self.window.rootViewController.view addSubview:self.synchronizationView];
}

- (void)hideSynchronizationView
{
    [self.synchronizationView removeFromSuperview];
}

@end
