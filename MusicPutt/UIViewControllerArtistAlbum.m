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
    
    NSLog(@"%@", [everything collections]);
    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[everything collections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d %d",section,[[everything collections][section] count]);
    return [[everything collections][section] count] ;
}

- (UITableViewCellArtistAlbum*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellArtistAlbum* cell = [tableView dequeueReusableCellWithIdentifier:@"CellArtistAlbum"];
    [cell setArtistAlbumItem: [[everything collections][indexPath.section] items][indexPath.row]] ;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. Dequeue the custom header cell
    UITableViewCellHeaderSection * headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
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
    
    // 2. Set the various properties
    headerCell.albumName.text = [[[everything collections][section] representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
    [headerCell.albumName sizeToFit];
    
    headerCell.artistName.text = [[[everything collections][section] representativeItem] valueForProperty:MPMediaItemPropertyAlbumArtist];
    [headerCell.artistName sizeToFit];
    
    // 3. And return
    return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
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
