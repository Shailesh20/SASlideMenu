//
//  SASlideContentSegue.m
//  SASlideMenu
//
//  Created by Stefano Antonelli on 1/17/13.
//  Copyright (c) 2013 Stefano Antonelli. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SASlideMenuContentSegue.h"
#import "SASlideMenuRootViewController.h"
#import "SASlideMenuViewController.h"

@implementation SASlideMenuContentSegue

-(void) perform{
 
    SASlideMenuViewController* source = self.sourceViewController;
    SASlideMenuRootViewController* rootController = source.rootController;
    UINavigationController* destination = self.destinationViewController;

    UIButton* menuButton = [[UIButton alloc] init];
    [rootController.leftMenu.slideMenuDataSource configureMenuButton:menuButton];
    [menuButton addTarget:rootController action:@selector(doSlideToSide) forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationItem* navigationItem = destination.navigationBar.topItem;
    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    Boolean hasRightMenu = NO;
    rootController.isRightMenuEnabled = NO;
    NSIndexPath* selectedIndexPath = [rootController.leftMenu.tableView indexPathForSelectedRow];

    if ([rootController.leftMenu.slideMenuDataSource respondsToSelector:@selector(hasRightMenuForIndexPath:)]) {
        hasRightMenu = [rootController.leftMenu.slideMenuDataSource hasRightMenuForIndexPath:selectedIndexPath];
    }
    if (hasRightMenu) {
        rootController.isRightMenuEnabled = YES;
        if ([rootController.leftMenu.slideMenuDataSource respondsToSelector:@selector(configureRightMenuButton:)]) {
            UIButton* rightMenuButton = [[UIButton alloc] init];
            [rootController.leftMenu.slideMenuDataSource configureRightMenuButton:rightMenuButton];
            [rightMenuButton addTarget:rootController action:@selector(rightMenuAction) forControlEvents:UIControlEventTouchUpInside];
            
            UINavigationItem* navigationItem = destination.navigationBar.topItem;
            navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightMenuButton];
        }
    }

    if([rootController.leftMenu.slideMenuDataSource respondsToSelector:@selector(configureSlideLayer:)]) {
        [rootController.leftMenu.slideMenuDataSource configureSlideLayer:[destination.view layer]];        
    }else{
        CALayer* layer = destination.view.layer;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOpacity = 0.3;
        layer.shadowOffset = CGSizeMake(-15, 0);
        layer.shadowRadius = 10;
        layer.masksToBounds = NO;
        layer.shadowPath =[UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
    }
    
    [rootController switchToContentViewController:destination];

    if ([rootController.leftMenu.slideMenuDataSource respondsToSelector:@selector(segueIdForIndexPath:)]) {
        [rootController addContentViewController:destination withIndexPath:selectedIndexPath];        
    }
       
    UIPanGestureRecognizer* panGesture= [[UIPanGestureRecognizer alloc] initWithTarget:rootController action:@selector(panItem:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:source];
    [panGesture setCancelsTouchesInView:NO];
    
    [destination.view addGestureRecognizer:panGesture];
}

@end