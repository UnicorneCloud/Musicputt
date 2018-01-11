//
//  UITabBarControllerMain.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-03.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITabBarControllerMain.h"

#import "AppDelegate.h"

@interface UITabBarControllerMain () <UITabBarControllerDelegate>

/**
 *  App delegate
 */
@property AppDelegate* del;

@end

@implementation UITabBarControllerMain

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup app delegate
    self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.del.mpdatamanager.tabbar = self;
    
    // setup current navigation controller
    self.del.mpdatamanager.currentNavController = (UINavigationController *) [self.viewControllers objectAtIndex:0];
    
    // setup PanGesture for the main menu
    // WARNING: cause some strang effect with list. Sometimes the menu popup when we eant to go down in list.
    // for this reason, I temporary disabled the panGesture for the main menu.
    // [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController.tabBarItem.title isEqualToString:@"menu"] )
    {
        // if selected view is the menu popup menu
        [[_del mainMenu] presentMenuViewController];
        return NO;
    }
    else
    {
        // if selectview isn't menu, hide menu
        [[_del mainMenu] hideMenuViewController];
    }
    return YES;
    //this doesnt stop any views being presented
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //if you're using navigationController
    UINavigationController *navC=(UINavigationController *)viewController;
    _del.mpdatamanager.currentNavController = navC;
    
    //NSArray *arrayVc=navC.viewControllers;
    //NSLog(@"%@",arrayVc);
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
