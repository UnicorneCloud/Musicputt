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

@interface UIViewControllerAlbumSongs ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    MPMediaQuery* everything;                   // result of current query
    NSNumber *fullLength;
    MPMediaItemCollection* albumCollection;
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
    
    // setup title
    [self setTitle:[[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle]];
    
    // setup tableview
    scrollView = _tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [albumCollection items].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellMediaItem* cell = [tableView dequeueReusableCellWithIdentifier:@"MediaItemCell"];
    [cell setAlbumSongItem: [albumCollection items][indexPath.row]];
    
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
    NSUInteger nbTracks = [albumsCollection items].count;
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
    [[albumsCollection items] enumerateObjectsUsingBlock:^(MPMediaItem *songItem, NSUInteger idx, BOOL *stop) {
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
        NSInteger maxstep    = [albumCollection items].count;
        NSUInteger pos       = indexPath.row;
        
        while (step<maxstep) {
            [list addObject: [[albumCollection items] objectAtIndex:pos]];
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
