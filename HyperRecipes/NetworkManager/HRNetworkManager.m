//
//  HRNetworkManager.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRNetworkManager.h"
#import "AFNetworking.h"
#import "HRRecipeMapper.h"
#import "HRRecipe.h"

static NSString *const kApiBaseURLString = @"http://hyper-recipes.herokuapp.com";

@implementation HRNetworkManager

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

#pragma mark - Public

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[super allocWithZone:nil] init];
    });
    
    return sharedInstance;
}

- (void)synchronizeDbInContext:(NSManagedObjectContext *)managedObjectContext
         withCompletionHandler:(void (^)(BOOL success))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@.json", kApiBaseURLString, @"recipes"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        
        dispatch_queue_t queue = dispatch_queue_create("com.hyperrecipes.queue", DISPATCH_QUEUE_CONCURRENT);
        
        for (id representation in responseObject) {
            dispatch_async(queue, ^{
                [self insertOrUpdateRecipeFromRepresentation:representation inManagedObjectContext:managedObjectContext];
            });
        }
        
        dispatch_barrier_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // Save context.
                NSError *error;
                if (![managedObjectContext save:&error]) {
                    NSLog(@"Error: %@", error);
                    
                    if (completion) {
                        completion(NO);
                    }
                } else {
                    if (completion) {
                        completion(YES);
                    }
                }
            });
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)createRecipe:(HRRecipe *)recipe
         withContext:(NSManagedObjectContext *)managedObjectContext
withCompletionHandler:(void (^)(BOOL success, NSDictionary* attributes))completion
{
    NSDictionary *managedObjectAttributes = [recipe dictionaryWithValuesForKeys:[recipe.entity.attributesByName allKeys]];
    
    HRRecipeMapper *recipeParser = [HRRecipeMapper new];
    [recipeParser representationOfAttributes:managedObjectAttributes withCompletionHandler:^(NSDictionary *parameters) {
        
        UIImage *photoImage = recipe.photo;
        NSData *photoImageData = UIImageJPEGRepresentation(photoImage, 90);
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@.json", kApiBaseURLString, @"recipes"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (photoImageData) {
                NSString* uuid = [[NSProcessInfo processInfo] globallyUniqueString];
                [formData appendPartWithFileData:photoImageData name:@"recipe[photo]"
                                        fileName:[NSString stringWithFormat:@"%@.jpg",uuid]
                                        mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"HRRecipe" inManagedObjectContext:managedObjectContext];
            
            NSDictionary *attributes = [recipeParser attributesForRepresentation:responseObject ofEntity:entityDescription];
            
            if (completion) {
                completion(YES, attributes);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            if (completion) {
                completion(NO, nil);
            }
        }];
    }];
}

- (void)updateRecipe:(HRRecipe *)recipe withCompletionHandler:(void (^)(BOOL success))completion
{
    HRRecipeMapper *recipeParser = [HRRecipeMapper new];
    
    NSDictionary *managedObjectAttributes = [recipe dictionaryWithValuesForKeys:[recipe.entity.attributesByName allKeys]];
    
    [recipeParser representationOfAttributes:managedObjectAttributes withCompletionHandler:^(NSDictionary *parameters) {
        UIImage *photoImage = recipe.photo;
        NSData *photoImageData = UIImageJPEGRepresentation(photoImage, 90);
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d", kApiBaseURLString, @"recipes", [recipe.referenceID integerValue]];
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (photoImageData) {
                NSString* uuid = [[NSProcessInfo processInfo] globallyUniqueString];
                [formData appendPartWithFileData:photoImageData name:@"recipe[photo]"
                                        fileName:[NSString stringWithFormat:@"%@.jpg",uuid]
                                        mimeType:@"image/jpeg"];
            }
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSProgress *progress = nil;
        
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
                
                if (completion) {
                    completion(NO);
                }
            } else {
                NSLog(@"%@ %@", response, responseObject);
                
                if (completion) {
                    completion(YES);
                }
            }
        }];
        
        [uploadTask resume];
    }];
}

- (void)deleteRecipe:(HRRecipe *)recipe withCompletionHandler:(void (^)(BOOL success))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d", kApiBaseURLString, @"recipes", [recipe.referenceID integerValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (completion) {
            completion(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (completion) {
            completion(NO);
        }
    }];
}

#pragma mark - Private

- (void)insertOrUpdateRecipeFromRepresentation:(id)representation inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    @try {
        HRRecipeMapper *recipeParser = [HRRecipeMapper new];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"HRRecipe" inManagedObjectContext:managedObjectContext];
        
        NSDictionary *attributes = [recipeParser attributesForRepresentation:representation ofEntity:entityDescription];
        
        NSString *referenceID = [attributes objectForKey:@"referenceID"];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        [fetchRequest setEntity:entityDescription];
        [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"referenceID == %@", referenceID]];
        
        NSError *error;
        NSArray *recipes = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        HRRecipe *recipe = nil;
        if (recipes.count > 0) {
            recipe = [recipes objectAtIndex:0];
        } else {
            recipe = [NSEntityDescription insertNewObjectForEntityForName:@"HRRecipe" inManagedObjectContext:managedObjectContext];
        }
        
        [recipe setValuesForKeysWithDictionary:attributes];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

@end
