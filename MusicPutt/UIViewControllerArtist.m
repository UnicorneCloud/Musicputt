//
//  UIViewControllerArtist.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerArtist.h"
#import "UITableViewCellArtist.h"
#import "AppDelegate.h"
#import <MediaPlayer/MPMediaQuery.h>

@interface UIViewControllerArtist ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    MPMediaQuery* everything;             // result of current query
    NSArray*      artists;
    NSMutableDictionary *artistDictionary;
}
@property AppDelegate* del;
@property (weak, nonatomic) IBOutlet UITableView*  tableView;
@end

@implementation UIViewControllerArtist

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
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Begin");
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"Artistes"];
    
    // setup tableview
    toolbarTableView = _tableView;
    
    // setup query playlist
    everything = [MPMediaQuery artistsQuery];
    //[everything setGroupingType:MPMediaGroupingArtist];
    artists = [everything collections];
    
    // Initiate the dictionnairy and fill it.
    artistDictionary = [NSMutableDictionary dictionary];
    NSMutableSet *tempSet = [NSMutableSet set];
    
    [artists enumerateObjectsUsingBlock:^(MPMediaItemCollection *artistCollection, NSUInteger idx, BOOL *stop) {
        NSString *artistName = [[artistCollection representativeItem] valueForProperty:MPMediaItemPropertyArtist];
        
        [[artistCollection items] enumerateObjectsUsingBlock:^(MPMediaItem *songItem, NSUInteger idx, BOOL *stop) {
            NSString *albumName = [songItem valueForProperty:MPMediaItemPropertyAlbumTitle];
            [tempSet addObject:albumName];
        }];
        [artistDictionary setValue:[NSNumber numberWithUnsignedInteger:[tempSet count]]
                            forKey:artistName];
        [tempSet removeAllObjects];
    }];
    NSLog(@"Artist Album Count Dictionary: %@", artistDictionary);
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Completed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return artists.count;
}

- (UITableViewCellArtist*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellArtist* cell = [tableView dequeueReusableCellWithIdentifier:@"CellArtist"];
    MPMediaItemCollection *collection = artists[indexPath.row];
    MPMediaItem * item =  [collection representativeItem];
    
    if([collection count]>0)
    {
        UIImage* image;
        MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork)
            image = [artwork imageWithSize:[cell.imageview frame].size];
        if (image.size.height>0 && image.size.width>0) // check if image present
            [cell.imageview setImage:image];
        else
            [cell.imageview setImage:[UIImage imageNamed:@"empty"]];
    }
    else
    {
        [cell.imageview setImage:[UIImage imageNamed:@"empty"]];
    }
    cell.artistName.text = [item valueForProperty:MPMediaItemPropertyArtist];
    
    NSUInteger nbAlbums = [[artistDictionary objectForKey:(cell.artistName.text)] intValue];
    if(nbAlbums>1)
    {
        cell.nbAlbums.text = [NSString stringWithFormat:@"%d albums", nbAlbums];
    }
    else
    {
        cell.nbAlbums.text = [NSString stringWithFormat:@"%d album", nbAlbums];
    }
    
    NSUInteger nbTracks = [collection count];
    if(nbTracks>1)
    {
        cell.nbTracks.text = [NSString stringWithFormat:@"%d tracks", nbTracks];
    }
    else
    {
        cell.nbTracks.text = [NSString stringWithFormat:@"%d track", nbTracks];
    }
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, [item valueForProperty:MPMediaItemPropertyArtist]);
    
    NSLog(@"Album number : %@\n", [artistDictionary objectForKey:(cell.artistName.text)]);
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
