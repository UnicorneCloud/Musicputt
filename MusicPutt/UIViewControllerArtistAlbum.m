//
//  UIViewControllerArtistAlbum.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-05.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerArtistAlbum.h"
#import "UITableViewCellArtistAlbum.h"
#import "UITableViewCellHeaderSection.h"
#import "AppDelegate.h"
#import <MediaPlayer/MPMediaQuery.h>

@interface UIViewControllerArtistAlbum () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchResultsUpdating>
{
    MPMediaQuery* everything;             // result of current query
    MPMediaItemCollection *artistCollection;
    NSNumber *fullLength;
}

@property AppDelegate* del;

@property (weak, nonatomic) IBOutlet UITableView*  tableView;

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic)UISearchController *searchController;

@end

@implementation UIViewControllerArtistAlbum

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  <#Description#>
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // setup app delegate
    self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    artistCollection = [[self.del mpdatamanager] currentArtistCollection];
    
    // Find out all the medias which match the current artist name.
    everything = [MPMediaQuery albumsQuery];
    MPMediaPropertyPredicate *artistPredicate =
    [MPMediaPropertyPredicate predicateWithValue:[[artistCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist]
                              forProperty:MPMediaItemPropertyAlbumArtist];
    [everything addFilterPredicate:artistPredicate];
    
    // setup title
    [self setTitle:[[artistCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist]];
    
    // setup tableview
    scrollView = _tableView;
    
    // setup search controller
    self.searchResults = [NSMutableArray arrayWithCapacity:[artistCollection count]];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.showsCancelButton = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
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
    self.searchController.searchBar.hidden = false;
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchController.searchBar.hidden = true;
    [self dismissKeyboard];
}

/**
 *  Number of section in the table view.
 *
 *  @param tableView :
 *
 *  @return          : Number of section. 
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.searchController isActive])
    {
        return 1;
    }
    else
    {
      return [[everything collections] count];
    }
}

/**
 *  The number of rows in the specified section.
 *
 *  @param tableView <#tableView description#>
 *  @param section   : Section's index.
 *
 *  @return          : Number of row of this section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchController isActive])
    {
        return [self.searchResults count]; //[everything collections].count;
    }
    else
    {
        return [[everything collections][section] count] ;
    }
}

/**
 *  Return the cell at a specified location in the talbe view.
 *
 *  @param tableView :
 *  @param indexPath : The path to the cell.
 *
 *  @return
 */
- (UITableViewCellArtistAlbum*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellArtistAlbum* cell = [tableView dequeueReusableCellWithIdentifier:@"CellArtistAlbum"];

    // check if editing playlist is active
    if ([[self.del mpdatamanager] isPlaylistEditing]) {
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[cell songDuration] setHidden:TRUE];   // hide duration
        [[cell add] setHidden:FALSE];           // show add button
    }
    else{
        [[cell songDuration] setHidden:FALSE];   // show duration
        [[cell add] setHidden:TRUE];             // hide add button
    }
    
    if (self.searchController.active)
    {
        MPMediaItemCollection *itemCollection =(MPMediaItemCollection*)(self.searchResults[indexPath.row]);
        [cell setArtistAlbumItem: itemCollection.items[0]] ;
    }
    else
    {
        [cell setArtistAlbumItem: [[everything collections][indexPath.section] items][indexPath.row]] ;
    }
    return cell;
}
/**
 *  Calculate the playback duration of full album.
 *
 *  @param indexAlbum : Album index or section.
 *
 *  @return           : The full duration of the album.
 */
- (NSString*) fullAlbumLength:(NSInteger)indexAlbum
{
    fullLength = 0;
    [[[everything collections][indexAlbum] items] enumerateObjectsUsingBlock:^(MPMediaItem *songItem, NSUInteger idx, BOOL *stop) {
        fullLength = @([fullLength floatValue] + [[songItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue]);
    }];
    
    int fullMinutes = trunc([fullLength floatValue]) / 60;
    
    NSString* length = [NSString stringWithFormat:@"%d mins",fullMinutes];
    return length;
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
    if(self.searchController.isActive)
    {
       return nil;
    }
    UITableViewCellHeaderSection * headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    headerCell.contentView.backgroundColor = [UIColor whiteColor];
    
    // Image of album's cover.
    if([artistCollection count]>0)
    {
        UIImage* image;
        MPMediaItemArtwork *artwork = [[[everything collections][section] representativeItem] valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork)
            image = [artwork imageWithSize:[[headerCell imageHeader] frame].size];
        if (image.size.height>0 && image.size.width>0) // check if image present
            [[headerCell imageHeader] setImage:image];
        else
            [[headerCell imageHeader] setImage:[UIImage imageNamed:@"empty"]];
    }
    
    // Album's name.
    headerCell.albumName.text = [[[everything collections][section] representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
    [headerCell.albumName sizeToFit];
    
    NSNumber *trackCount = [NSNumber numberWithInteger:([[[everything collections][section] items] count])];
    if (trackCount.integerValue > 1)
    {
        headerCell.infoAlbum.text = [trackCount.stringValue stringByAppendingString:@" tracks"];
    }
    else if (trackCount.integerValue > 0)
    {
        headerCell.infoAlbum.text = [trackCount.stringValue stringByAppendingString:@" track"];
    }
    else
    {
        headerCell.infoAlbum.text = @"";
    }
    
    // Album's duration.
    NSString *strLength = [self fullAlbumLength:section];
    if (strLength != nil)
    {
        if(trackCount > 0)
        {
            headerCell.infoAlbum.text = [headerCell.infoAlbum.text stringByAppendingString: @", "];
        }
        headerCell.infoAlbum.text = [headerCell.infoAlbum.text stringByAppendingString: strLength];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    headerCell.albumYear.text = [formatter stringFromDate:[[[everything collections][section] representativeItem] valueForProperty:MPMediaItemPropertyReleaseDate]];
    
    return headerCell;
}

/**
 *  Set the section header's height.
 *
 *  @param tableView : Table view for this section.
 *  @param section   : Section index.
 *
 *  @return          : Section hearder's height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchController.isActive) {
        return 0.0f;
    }
    return 80.0f;
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

/**
 *  Get the global position of selected item in liste to play.
 *
 *  @param indexPath : The path of the selected item.
 *
 *  @return          : the global position.
 */
- (NSUInteger)getGlobalItemPos:(NSIndexPath*)indexPath
{
    return indexPath.row + [self getItemNumberBeforeSection:indexPath.section];
}

/**
 *  Get the count of total items located before the section.
 *
 *  @param section : The section of the table.
 *
 *  @return        : the count of total items located before the section.
 */
- (NSUInteger)getItemNumberBeforeSection:(NSUInteger) section
{
    NSUInteger itemCount = 0;
    if (section > 0)
    {
        for(NSUInteger i = 0; i < section-1; i++)
        {
            itemCount += [[everything collections][i] items].count;
        }
    }
    
    return itemCount;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellArtistAlbum* cell = (UITableViewCellArtistAlbum*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    
    // check if editing playlist is active
    if ([[self.del mpdatamanager] isPlaylistEditing]) {
        
        return nil; // cancel row selection
    }
    else{
        NSMutableArray* list = [[NSMutableArray alloc] init];
        NSInteger step = 0;
        NSInteger maxstep = 0;
        
        maxstep = [self getItemNumberBeforeSection: [[everything collections] count] + 1];
        
        NSInteger  currentSection = indexPath.section;
        // Global position of item in the list.
        NSUInteger pos = [self getGlobalItemPos:indexPath];
        
        NSUInteger localPos = indexPath.row;
        
        while (step<maxstep) {
            [list addObject: [[[everything collections][currentSection] items] objectAtIndex:localPos]];
            //NSLog(@"%@", [list[step] valueForProperty:MPMediaItemPropertyTitle]);
            step++;
            pos++;
            localPos++;
            
            // update the section when reading the next album.
            if (localPos == [[everything collections][currentSection] items].count)
                
            {
                // If it's not the last section.
                if(currentSection < ([self numberOfSectionsInTableView:_tableView] - 1))
                {
                    currentSection++;
                }
                // Go to the first section if it's the last section in the table view.
                else
                {
                    currentSection = 0;
                }
                localPos = 0;
            }
            
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

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
*/
-(IBAction)toggleSearch:(id)sender
{
    // hide the search bar when it's showed
    NSLog(@"self.tableView.bounds.origin.y = %f", self.tableView.bounds.origin.y);
    
    if (self.tableView.bounds.origin.y == -64) {
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.frame.size.height-70, 1, 1) animated:YES];
    }
    else
    {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    [self updateFilteredContentForArtistSong:searchString];
    [self.tableView reloadData];
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForArtistSong:(NSString *)searchText
{
    if ((searchText == nil) || [searchText length] == 0)
    {
        everything = [MPMediaQuery albumsQuery];
        MPMediaPropertyPredicate *artistPredicate =
        [MPMediaPropertyPredicate predicateWithValue:[[artistCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist]
                                         forProperty:MPMediaItemPropertyAlbumArtist];
        [everything addFilterPredicate:artistPredicate];
        return;
    }
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    // Find out all the medias which match the current item title.
    everything = [MPMediaQuery songsQuery];
    
    MPMediaPropertyPredicate *artistPredicate =
    [MPMediaPropertyPredicate predicateWithValue:[[artistCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist]
                                     forProperty:MPMediaItemPropertyAlbumArtist];
    [everything addFilterPredicate:artistPredicate];
    
    MPMediaPropertyPredicate *songTitlePredicate =
    [MPMediaPropertyPredicate predicateWithValue:searchText
                                     forProperty:MPMediaItemPropertyTitle
                                  comparisonType:MPMediaPredicateComparisonContains];
    [everything addFilterPredicate:songTitlePredicate];

    for (MPMediaItemCollection *itemCollection in everything.collections)
    {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        MPMediaItem* itemRepresentativeItem = [(MPMediaItemCollection*)itemCollection representativeItem];
        NSString *name = [itemRepresentativeItem valueForProperty:MPMediaItemPropertyTitle];
        NSRange itemNameRange = NSMakeRange(0, name.length);
        NSRange foundRange = [name rangeOfString:searchText options:searchOptions range:itemNameRange];
        if (foundRange.length > 0)
        {
            [self.searchResults addObject:itemCollection];
        }
    }
}

- (void)dismissKeyboard
{
    [[self.del window] endEditing:YES];
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
