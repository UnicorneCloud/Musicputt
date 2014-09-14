//
//  UIViewControllerAlbumStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerAlbumStore.h"

#import "AppDelegate.h"

@interface UIViewControllerAlbumStore ()

@property AppDelegate* del;

/**
 * Table of songs
 */
@property (weak, nonatomic) IBOutlet UITableView* songstable;


@end

@implementation UIViewControllerAlbumStore

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup app delegate
    self.del = [[UIApplication sharedApplication] delegate];
    
    // setup title
    [self setTitle:@"Feature"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.songstable visibleCells];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
