//
//  UIViewControllerAlbumStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-09-13.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerAlbumStore.h"

#import "AppDelegate.h"
#import "TableViewCellAlbumStoreHeader.h"

@interface UIViewControllerAlbumStore () <UITableViewDelegate, UITableViewDataSource>

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
    
    // setup tableview
    toolbarTableView = _songstable;
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


/**
 *  Number of section in the table view.
 *
 *  @param tableView :
 *
 *  @return          : Number of section.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    return 0;
}

/**
 *  Return the cell at a specified location in the talbe view.
 *
 *  @param tableView :
 *  @param indexPath : The path to the cell.
 *
 *  @return
 */
- (TableViewCellAlbumStoreHeader*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellAlbumStoreHeader * headerCell = [tableView dequeueReusableCellWithIdentifier:@"AlbumStoreHeaderCell"];
    return headerCell;
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
    TableViewCellAlbumStoreHeader * headerCell = [tableView dequeueReusableCellWithIdentifier:@"AlbumStoreHeaderCell"];
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
    return 80.0f;
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
