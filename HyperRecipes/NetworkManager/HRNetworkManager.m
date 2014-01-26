//
//  HRNetworkManager.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/26/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRNetworkManager.h"
#import "AFNetworking.h"
#import "HRRecipeParser.h"
#import "HRRecipe.h"

//static NSString *const kApiBaseURLString = @"http://0.0.0.0:3000";
static NSString *const kApiBaseURLString = @"http://hyper-recipes.herokuapp.com1";

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

- (void)synchronizeDbInContect:(NSManagedObjectContext *)managedObjectContext
         withCompletionHandler:(void (^)(BOOL success))completion;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@.json", kApiBaseURLString, @"recipes"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        HRRecipeParser *recipeParser = [HRRecipeParser new];
        
        @try {
            for (id representation in responseObject) {
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
            }
            
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
            
            
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
            
            if (completion) {
                completion(NO);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)createRecipe:(HRRecipe *)recipe withCompletionHandler:(void (^)(BOOL success))completion
{
    HRRecipeParser *recipeParser = [HRRecipeParser new];
    
    NSDictionary *managedObjectAttributes = [recipe dictionaryWithValuesForKeys:[recipe.entity.attributesByName allKeys]];
    
    NSDictionary *parameters = [recipeParser representationOfAttributes:managedObjectAttributes];

    UIImage *photoImage = recipe.photo;
    NSData *photoImageData = UIImageJPEGRepresentation(photoImage, 90);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@.json", kApiBaseURLString, @"recipes"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (photoImageData) {
            [formData appendPartWithFileData:photoImageData name:@"recipe[photo]" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
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

- (void)updateRecipe:(HRRecipe *)recipe withCompletionHandler:(void (^)(BOOL success))completion
{
    HRRecipeParser *recipeParser = [HRRecipeParser new];
    
    NSDictionary *managedObjectAttributes = [recipe dictionaryWithValuesForKeys:[recipe.entity.attributesByName allKeys]];
    
    NSDictionary *parameters = [recipeParser representationOfAttributes:managedObjectAttributes];
    
    UIImage *photoImage = recipe.photo;
    NSData *photoImageData = UIImageJPEGRepresentation(photoImage, 90);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d", kApiBaseURLString, @"recipes", [recipe.referenceID integerValue]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (photoImageData) {
            [formData appendPartWithFileData:photoImageData name:@"recipe[photo]" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
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

@end
