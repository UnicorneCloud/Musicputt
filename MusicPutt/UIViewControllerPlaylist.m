//
//  ViewControllerPlaylist.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-28.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerPlaylist.h"
#import "CurrentPlayingToolBar.h"

@interface UIViewControllerPlaylist () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    CurrentPlayingToolBar *currentPlayingToolBar;
}

@property (weak, nonatomic) IBOutlet UITableView*            tableView;

@end

@implementation UIViewControllerPlaylist

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
    
    [self setTitle:@"Playlists"];
    
    currentPlayingToolBar = [[CurrentPlayingToolBar alloc] init];
    currentPlayingToolBar.scrollView = self.tableView;
    [currentPlayingToolBar showFromNavigationBar:self.navigationController.navigationBar animated:YES];
    // to hide : [currentPlayingToolBar hideAnimated:YES];
}

-(void) done
{
    
}

-(void) cancel
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlaylist"];
    
    //cell.textLabel.text = @"text";
    //[cell setBackgroundColor:[UIColor clearColor]];
	//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //[cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];
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
