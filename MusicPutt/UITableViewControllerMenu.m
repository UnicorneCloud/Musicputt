//
//  UITableViewControllerMenu.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-03.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewControllerMenu.h"

#import "UIColor+CreateMethods.h"
#import "AppDelegate.h"

// TODO: adjust the app link
#define APP_URL_STRING  @"https://itunes.apple.com/us/app/calcfast/xxxxxxxxxxx?mt=8"

@interface UITableViewControllerMenu ()

/**
 *  App delegate
 */
@property AppDelegate* del;

@end

@implementation UITableViewControllerMenu

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 180.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"musicputt"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 0, 24)];
        label.text = @"musicputt";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithHex:@"#750300" alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UILabel *labelversion = [[UILabel alloc] initWithFrame:CGRectMake(0, 163, 0, 24)];
        labelversion.text = [self.del versionBuild];
        labelversion.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        labelversion.backgroundColor = [UIColor clearColor];
        labelversion.textColor = [UIColor colorWithHex:@"#750300" alpha:1.0f];
        [labelversion sizeToFit];
        labelversion.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:labelversion];
        view;
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // pop all view on the navigator controller
    // TODO: For this moment I can't pop all view on the controller.
    /*
    UINavigationController* curNav = [[_del mpdatamanager] currentNavController];
    for (NSInteger nbcontroller=curNav.childViewControllers.count ; nbcontroller>1; nbcontroller--)
    {
        [curNav popViewControllerAnimated:FALSE];
    }
    */
    
    //[currentNavControler popToRootViewControllerAnimated:FALSE];
    
    // change selection
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        // songlist
        [[[[self del] mpdatamanager] tabbar] setSelectedIndex:0];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        // Playlists
        [[[[self del] mpdatamanager] tabbar] setSelectedIndex:1];
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        // Albums
        [[[[self del] mpdatamanager] tabbar] setSelectedIndex:2];
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        // Artist
        [[[[self del] mpdatamanager] tabbar] setSelectedIndex:3];
    }
    
    /*
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        // Rate this app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: APP_URL_STRING]];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        // Share this app
        NSString* sharedString = [NSString stringWithFormat:@"I'm discover a great app musicputt!"];
        UIImage* sharedImage = [UIImage imageNamed:@"empty"];
        NSURL* sharedUrl = [NSURL URLWithString:APP_URL_STRING];
        
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[sharedString, sharedImage, sharedUrl] applicationActivities:nil];
        controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact];
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    else */
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        // About
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *aboutView = [sb instantiateViewControllerWithIdentifier:@"About"];
        
        // This is where you wrap the view up nicely in a navigation controller
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:aboutView];
        
        // And now you want to present the view in a modal fashion
        [self.del.mpdatamanager.tabbar presentViewController:navigationController animated:TRUE completion:nil];
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        // Main section as 4 menu items
        return 4;
    }
    else
    {
        // Settings section as 3 menu items
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    if (sectionIndex==0)
        label.text = @"Main section"; // main section
    else
        label.text = @"Settings"; // Settings
    
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        NSArray *titles = @[@"Feature", @"Playlists", @"Albums", @"Artists"];
        cell.textLabel.text = titles[indexPath.row];
    }
    else
    {
        NSArray *titles = @[/*@"Rate this app", @"Share this app", */@"About"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
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
