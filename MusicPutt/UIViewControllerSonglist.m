//
//  UIViewControllerSonglistView.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-07-01.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerSonglist.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIViewControllerPlaylist.h"
#import "UITableViewCellSong.h"
#import "AppDelegate.h"

@interface UIViewControllerSonglist ()  <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView*            tableView;
@property AppDelegate* del;

@end

@implementation UIViewControllerSonglist

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
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"Songlist"];
    
    // setup tableview
    toolbarTableView = _tableView;
    
    // setup empty view
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    
    // setup table to permit row move
    [self.tableView setEditing:NO animated:YES];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView - Move cell

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{

}


#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.del.mpdatamanager.currentSonglist.count;
}


- (UITableViewCellSong*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* songs = self.del.mpdatamanager.currentSonglist;
    UITableViewCellSong* cell = [tableView dequeueReusableCellWithIdentifier:@"CellSong"];
    MPMediaItem* item = songs[indexPath.row];
    cell.title.text = [item valueForProperty:MPMediaItemPropertyTitle];
    cell.artist.text = [item valueForProperty:MPMediaItemPropertyArtist];
    cell.album.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    UIImage* image;
    MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork)
        image = [artwork imageWithSize:[cell.imageview frame].size];
    if (image.size.height>0 && image.size.width>0) // check if image present
        [cell.imageview setImage:image];
    else
        [cell.imageview setImage:[UIImage imageNamed:@"empty"]];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"Empty Songlist!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"You have to select songs to create your Songlist! Click continue to select song.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0]};
    return [[NSAttributedString alloc] initWithString:@"Continue" attributes:attributes];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView 
{
    
    return [UIImage imageNamed:@"treble_clef"];
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIColor whiteColor];
}
/*
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    
    return YES;
}
*/

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    //UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UIViewControllerPlaylist *playlistView = [sb instantiateViewControllerWithIdentifier:@"Playlist"]; // @"SettingsListViewController" is the string you have set in above picture
    //[self.navigationController pushViewController:playlistView animated:YES];
    self.tabBarController.selectedIndex = 1;
}


- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    //UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UIViewControllerPlaylist *playlistView = [sb instantiateViewControllerWithIdentifier:@"Playlist"]; // @"SettingsListViewController" is the string you have set in above picture
    //[self.navigationController pushViewController:playlistView animated:YES];
    self.tabBarController.selectedIndex = 1;
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
