//
//  HRSynchronizationView.m
//  HyperRecipes
//
//  Created by Sergey Demchenko on 1/28/14.
//  Copyright (c) 2014 antrix1989@gmail.com. All rights reserved.
//

#import "HRSynchronizationView.h"

@interface HRSynchronizationView ()

@property (weak, nonatomic) IBOutlet UILabel *synchronizationLable;

@end

@implementation HRSynchronizationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.synchronizationLable.text = NSLocalizedString(@"Synchronization...", nil);
}

@end
