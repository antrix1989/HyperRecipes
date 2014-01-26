//
//  HRRecipeAddViewController.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/23/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRRecipeEditViewController.h"
#import "Recipe.h"

@interface HRRecipeEditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UISwitch *favoriteSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;

@property (strong, nonatomic) UIImage *pickedImage;
@property (strong, nonatomic) UITextView *activeTextView;
@property (assign, nonatomic) UIEdgeInsets scrollContentInsets;

- (IBAction)onAddButtonTapped:(id)sender;

@end

@implementation HRRecipeEditViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"INFO", nil);
    self.nameLabel.text = NSLocalizedString(@"NAME", nil);
    self.difficultyLabel.text = NSLocalizedString(@"DIFFICULITY", nil);
    self.favoriteLabel.text = NSLocalizedString(@"FAVORITE", nil);
    self.descriptionLabel.text = NSLocalizedString(@"DESCRIPTION", nil);
    self.instructionsLabel.text = NSLocalizedString(@"INSTRUCTIONS", nil);
    [self.addImageButton setTitle:NSLocalizedString(@"ADD IMAGE", nil) forState:UIControlStateNormal];
    [self.difficultySegmentControl setTitle:NSLocalizedString(@"Easy", nil) forSegmentAtIndex:0];
    [self.difficultySegmentControl setTitle:NSLocalizedString(@"Medium", nil) forSegmentAtIndex:1];
    [self.difficultySegmentControl setTitle:NSLocalizedString(@"Hard", nil) forSegmentAtIndex:2];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneButtonTapped:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancellButtonTapped:)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewTapped:)];
    // Prevents the scroll view from swallowing up the touch event of child buttons.
    tapGesture.cancelsTouchesInView = NO;
    
    [self.scrollView addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
    self.photoImageView.image = self.pickedImage ? : self.recipe.photo;
    
    // If image is shown, hide button title.
    if (self.photoImageView.image) {
        [self.addImageButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    if (!self.recipe) {
        return;
    }
        
    self.nameTextField.text = self.recipe.name;
    
    if (self.recipe.difficulty > 0) {
        self.difficultySegmentControl.selectedSegmentIndex = [self.recipe.difficulty integerValue] - 1;
    }
    
    self.descriptionTextView.text = self.recipe.overview;
    self.instructionsTextView.text = self.recipe.instructions;
    self.favoriteSwitch.on = [self.recipe.favorite boolValue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBAction

- (void)onDoneButtonTapped:(id)sender
{
    BOOL isNewRecipe = self.recipe == nil;
    
    if (!self.recipe) {
        self.recipe = [[Recipe alloc] initWithName:self.nameTextField.text inManagedObjectContext:self.managedObjectContext];
    } else {
        self.recipe.name = self.nameTextField.text;
    }
    
    self.recipe.difficulty = [[NSNumber alloc] initWithInt:self.difficultySegmentControl.selectedSegmentIndex + 1];
    self.recipe.overview = self.descriptionTextView.text;
    self.recipe.instructions = self.instructionsTextView.text;
    self.recipe.favorite = [[NSNumber alloc] initWithBool:self.favoriteSwitch.on];
    self.recipe.photo = self.photoImageView.image;

    if (isNewRecipe) {
        [self.managedObjectContext insertObject:self.recipe];
    }

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCancellButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onAddButtonTapped:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UITapGestureRecognizer

- (void)onScrollViewTapped:(UITapGestureRecognizer*)recognizer
{
    [self.activeTextView resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.activeTextView = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.activeTextView = nil;
}

#pragma mark - NSNotification

- (void)keyboardWasShown:(NSNotification*)notification
{
    self.scrollContentInsets = self.scrollView.contentInset;
    
    if ([self.nameTextField isFirstResponder]) {
        return;
    }
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible.
    CGRect frame = self.view.frame;
    frame.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(frame, self.activeTextView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeTextView.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    self.scrollView.contentInset = self.scrollContentInsets;
    self.scrollView.scrollIndicatorInsets = self.scrollContentInsets;
}

#pragma mark - Private

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

@end
