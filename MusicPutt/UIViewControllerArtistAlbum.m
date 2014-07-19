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

@interface UIViewControllerArtistAlbum () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    MPMediaQuery* everything;             // result of current query
    MPMediaItemCollection *artistCollection;
    NSNumber *fullLength;
}

@property AppDelegate* del;
@property (weak, nonatomic) IBOutlet UITableView*  tableView;

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
    self.del = [[UIApplication sharedApplication] delegate];
    
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
    toolbarTableView = _tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [[everything collections] count];
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
    return [[everything collections][section] count] ;
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
    [cell setArtistAlbumItem: [[everything collections][indexPath.section] items][indexPath.row]] ;
    
    return cell;
}
/**
 *  Calculate the playback duration of full album.
 *
 *  @param indexAlbum : Album index or section.
 *
 *  @return           : The full duration of the album.
 */
- (NSString*)fullAlbumLength:(NSInteger)indexAlbum
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
    if (trackCount > 0)
    {
        headerCell.infoAlbum.text = [trackCount.stringValue stringByAppendingString:@" tracks"];
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
 *  @param tableView
 *  @param section   : Section index.
 *
 *  @return          : Section hearder's height.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
            currentSection++;
            localPos = 0;
        }
        
        if(pos == maxstep)
        {
            pos=0;
            localPos = 0;
            currentSection = 0;
        }
    }

    [[[self.del mpdatamanager] musicplayer] stop];
    
    BOOL shuffleWasOn = NO;
    if ([[self.del mpdatamanager] musicplayer].shuffleMode != MPMusicShuffleModeOff)
    {
        [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeOff;
        shuffleWasOn = YES;
    }
    [[[self.del mpdatamanager] musicplayer] setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:list]];
    [[[self.del mpdatamanager] musicplayer] setNowPlayingItem:[cell getMediaItem]];
    if (shuffleWasOn)
        [[self.del mpdatamanager] musicplayer].shuffleMode = MPMusicShuffleModeSongs;
    
    [[[self.del mpdatamanager] musicplayer] play];
    
    self.del.mpdatamanager.currentSonglist = list;

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
