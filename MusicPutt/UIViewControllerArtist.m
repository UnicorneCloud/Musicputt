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
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"Artists"];
    
    // setup tableview
    toolbarTableView = _tableView;
    
    // setup query artists
    everything = [MPMediaQuery artistsQuery];

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
    [cell setArtistItem: artists[indexPath.row] withDictionnary:artistDictionary];

    return cell;
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
