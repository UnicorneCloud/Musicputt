//
//  UIViewControllerAlbumSongs.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-25.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerAlbumSongs.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UITableViewCellMediaItem.h"
#import "UITableViewCellMediaItemHeader.h"
#import "Playlist.h"
#import "PlaylistItem.h"

@interface UIViewControllerAlbumSongs ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchResultsUpdating>
{
    MPMediaQuery* everything;                   // result of current query
    NSNumber *fullLength;
    MPMediaItemCollection* albumCollection;
    NSArray* songs;
}

@property AppDelegate* del;

@property (weak, nonatomic) IBOutlet UITableView*  tableView;

@property (weak, nonatomic) IBOutlet UIImageView* imageview;

@property (weak, nonatomic) IBOutlet UILabel* albumname;

@property (weak, nonatomic) IBOutlet UILabel* albumlink;

@property (weak, nonatomic) IBOutlet UILabel* trackandduration;

@property (weak, nonatomic) IBOutlet UILabel* year;

@property (weak, nonatomic) IBOutlet UILabel* price;

@property (weak, nonatomic) IBOutlet UILabel* genre;

@property (weak, nonatomic) IBOutlet UITableView* songstable;

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic)UISearchController *searchController;

@end

@implementation UIViewControllerAlbumSongs

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
    
    albumCollection = [[self.del mpdatamanager] currentAlbumCollection];
    songs = [albumCollection items];
    // setup title
    [self setTitle:[[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle]];
    
    // setup tableview
    scrollView = _tableView;
    
    // setup search bar
    self.searchResults = [NSMutableArray arrayWithCapacity:songs.count];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.showsCancelButton = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 50.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self dismissKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[_tableView reloadData];
    self.searchController.searchBar.hidden = false;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchController.searchBar.hidden = true;
    [self dismissKeyboard];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If the requesting table view is the search display controller's table view, return the count of
    // the filtered list, otherwise return the count of the main list.
    if (self.searchController.active)
    {
        return [self.searchResults count];
    }
    else
    {
        return songs.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellMediaItem* cell = [tableView dequeueReusableCellWithIdentifier:@"MediaItemCell"];
   
    if (self.searchController.isActive)
    {
        [cell setAlbumSongItem: self.searchResults[indexPath.row]];
    }
    else
    {
        [cell setAlbumSongItem: songs[indexPath.row]];
    }
    
    // check if editing playlist is active
    if ([[self.del mpdatamanager] isPlaylistEditing])
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[cell songDuration] setHidden:TRUE];   // hide duration
        [[cell add] setHidden:FALSE];           // show add button
    }
    else
    {
        [[cell songDuration] setHidden:FALSE];   // show duration
        [[cell add] setHidden:TRUE];             // hide add button 
    }
    
    return cell;
}

/**
 *  Set the section header's height.
 *
 *  @param tableView
 *  @param section   : Section index.
 *
 *  @return          : Section hearder's height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

/**
 *  Create the header cell of the section in the table view.
 *
 *  @param tableView :
 *  @param section   : The section index.
 *  @return          : The header cell.
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCellMediaItemHeader *headerCell = [tableView dequeueReusableCellWithIdentifier:@"MediaItemHeaderCell"];
    headerCell.contentView.backgroundColor = [UIColor whiteColor];
    
    // Image of album's cover.
    if([albumCollection count]>0)
    {
        UIImage* image;
        MPMediaItemArtwork *artwork = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork)
            image = [artwork imageWithSize:[[headerCell imageHeader] frame].size];
        if (image.size.height>0 && image.size.width>0) // check if image present
            [[headerCell imageHeader] setImage:image];
        else
            [[headerCell imageHeader] setImage:[UIImage imageNamed:@"empty"]];
    }

    // Album's name.
    headerCell.albumName.text = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
    [headerCell.albumName sizeToFit];
    
    // Artist'name.
    headerCell.artistName.text = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist];
    [headerCell.artistName sizeToFit];
    
    headerCell.infoAlbum.text = [[self getAlbumTracksCount:albumCollection] stringByAppendingString:[self getAlbumDuration:albumCollection]];
    [headerCell.artistName sizeToFit];

    return headerCell;
}

/**
 *  Get the number of tracks in the album.
 *
 *  @param albumsCollection : Collection of media item of the album.
 *
 *  @return                 : The number of tracks in the album.
 */
- (NSString*) getAlbumTracksCount:(MPMediaItemCollection*)albumsCollection
{
    NSUInteger nbTracks = songs.count;
    NSString*  str;
    
    if (nbTracks > 1)
    {
        str = [NSString stringWithFormat: @"%lu tracks, ", (unsigned long)nbTracks];
    }
    else if(nbTracks > 0)
    {
        str = [NSString stringWithFormat: @"%lu track, ", (unsigned long)nbTracks];
    }
    else
    {
        str = @"";
    }
    return str;
}

/**
 *  Get the full album duration
 *
 *  @param albumsCollection : Collection of media item of the album.
 *
 *  @return                 : The duration of album.
 */
- (NSString*) getAlbumDuration:(MPMediaItemCollection*)albumsCollection
{
    fullLength = 0;
    [songs enumerateObjectsUsingBlock:^(MPMediaItem *songItem, NSUInteger idx, BOOL *stop) {
        fullLength = @([fullLength floatValue] + [[songItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue]);
    }];
    
    int fullMinutes = trunc([fullLength floatValue]) / 60;
    
    NSString* length = [NSString stringWithFormat:@"%d mins",fullMinutes];
    
    return length;
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

#pragma mark - UITableViewDelegate

/**
 *  This function add the songs to play in a list when user click the first song.
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellMediaItem* cell = (UITableViewCellMediaItem*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    
    // check if editing playlist is active
    if ([[self.del mpdatamanager] isPlaylistEditing]) {

        return nil; // cancel row selection
    }
    else{
        NSMutableArray* list = [[NSMutableArray alloc] init];
        NSInteger step       = 0;
        NSInteger maxstep    = songs.count;
        NSUInteger pos       = indexPath.row;
        
        while (step<maxstep) {
            [list addObject: [songs objectAtIndex:pos]];
            step++;
            pos++;
            
            if(pos == maxstep)
            {
                pos=0;
            }
        }
        
        [[[self.del mpdatamanager] musicplayer] stop];
        
        BOOL shuffleWasOn = NO;
        if ([[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeOff &&
            [[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeDefault)
        {
            [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeOff;
            shuffleWasOn = YES;
        }
        [[[self.del mpdatamanager] musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:list]];
        [[[self.del mpdatamanager] musicplayer] setNowPlayingItem:[cell getMediaItem]];
        if (shuffleWasOn)
            [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeSongs;
        
        [[[self.del mpdatamanager] musicplayer] play];
        
        // save last playing album
        [[self.del mpdatamanager] setLastPlayingAlbum:[NSNumber numberWithLongLong:[cell getMediaItem].albumPersistentID]];
    }
    
    return indexPath;
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    [self updateFilteredContentForAlbumSongs:searchString];
    [self.tableView reloadData];
}

-(IBAction)toggleSearch:(id)sender
{
    // hide the search bar when it's showed
    NSLog(@"self.tableView.frame.origin.y = %f", self.tableView.frame.origin.y);
    NSLog(@"self.tableView.bounds.origin.y = %f", self.tableView.bounds.origin.y);
    
    if (self.tableView.bounds.origin.y == -64)
    {
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.frame.size.height-70, 1, 1) animated:YES];
    }
    else
    {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}


#pragma mark - Content Filtering

- (void)updateFilteredContentForAlbumSongs:(NSString *)songName
{
    if ((songName == nil) || [songName length] == 0)
    {
        self.searchResults = [songs mutableCopy];
        return;
    }
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    NSLog(@"before %d",[self searchController].active);
    // Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
    for (MPMediaItem* mediaItem in songs)
    {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSString *name = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        NSRange mediaNameRange = NSMakeRange(0, name.length);
        NSRange foundRange = [name rangeOfString:songName options:searchOptions range:mediaNameRange];
        if (foundRange.length > 0)
        {
            [self.searchResults addObject:mediaItem];
        }
    }
    NSLog(@"after %d",[self searchController].active);
}

- (void)dismissKeyboard
{
    [[self.del window] endEditing:YES];
}








@end
