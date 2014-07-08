//
//  UIViewControllerArtistAlbum.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-05.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerArtistAlbum.h"
#import "AppDelegate.h"
#import <MediaPlayer/MPMediaQuery.h>

@interface UIViewControllerArtistAlbum () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    MPMediaQuery* everything;             // result of current query
    NSArray*      artists;
    NSMutableDictionary *artistDictionary;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NULL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
