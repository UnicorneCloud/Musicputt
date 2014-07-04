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
//#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMediaQuery.h>

@interface UIViewControllerArtist ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    MPMediaQuery* everything;             // result of current query
    NSArray*      artists;
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
    [everything setGroupingType:MPMediaGroupingAlbumArtist];
    artists = [everything collections];
    
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
    MPMediaItem * item =  [artists[indexPath.row] representativeItem];
    cell.artistName.text = [item valueForProperty:MPMediaPlaylistPropertyName];
    //cell.nbTracks.text = [NSString stringWithFormat:@"%lu track(s)", (unsigned long)item.count];
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, [item valueForProperty:MPMediaItemPropertyAlbumArtist]);
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
