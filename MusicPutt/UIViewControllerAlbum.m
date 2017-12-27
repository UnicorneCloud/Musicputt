//
//  UIViewControllerAlbum.m
//  MusicPutt
//
//  Created by Qiaomei Wang on 2014-07-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerAlbum.h"
#import "UITableViewCellAlbum.h"
#import "AppDelegate.h"
#import <MediaPlayer/MPMediaQuery.h>

@interface UIViewControllerAlbum ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchResultsUpdating>
{
    MPMediaQuery* everything;             // result of current query
    NSArray*      albums;
}
@property AppDelegate* del;
@property (weak, nonatomic) IBOutlet UITableView*  tableView;
@property (nonatomic)UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation UIViewControllerAlbum

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
    self.del = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    // setup title
    [self setTitle:@"Albums"];
        
    // setup tableview
    scrollView = _tableView;
    
    // setup query artists
    everything = [MPMediaQuery albumsQuery];
    albums = [everything collections];
    
    // setup search bar
    self.searchResults = [NSMutableArray arrayWithCapacity:[albums count]];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.showsCancelButton = NO;
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = false;
    //self.searchController.active = true;
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchController.searchBar.hidden = true;
    self.searchController.active = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If the requesting table view is the search display controller's table view, return the count of
    // the filtered list, otherwise return the count of the main list.
    if (self.searchController.isActive)
    {
        return [self.searchResults count];
    }
    else
    {
        return albums.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellAlbum* cell = [tableView dequeueReusableCellWithIdentifier:@"CellAlbum"];
    
    if (self.searchController.isActive)
    {
        [cell setAlbumItem: self.searchResults[indexPath.row]];
    }
    else
    {
        [cell setAlbumItem: albums[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.isActive)
    {
        [self.del mpdatamanager].currentAlbumCollection = self.searchResults[indexPath.row];
    }
    else
    {
        [self.del mpdatamanager].currentAlbumCollection = albums[indexPath.row];
    }

    return indexPath;
}

#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    [self updateFilteredContentForAlbum:searchString];
    [self.tableView reloadData];
}

-(IBAction)toggleSearch:(id)sender
{
    // hide the search bar when it's showed
    NSLog(@"self.tableView.frame.origin.y = %f", self.tableView.frame.origin.y);
    NSLog(@"self.tableView.bounds.origin.y = %f", self.tableView.bounds.origin.y);
    
    if (self.tableView.bounds.origin.y == -64)
    {
        [[self searchController] setActive: false];
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.frame.size.height-70, 1, 1) animated:YES];
    }
    else
    {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForAlbum:(NSString *)albumName
{
    if ((albumName == nil) || [albumName length] == 0)
    {
        self.searchResults = [albums mutableCopy];
        return;
    }
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    // Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
    for (MPMediaItemCollection *albumCollection in albums)
    {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        MPMediaItem* albumRepresentativeItem = [(MPMediaItemCollection*)albumCollection representativeItem];
        NSString *name = [albumRepresentativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        NSRange albumNameRange = NSMakeRange(0, name.length);
        NSRange foundRange = [name rangeOfString:albumName options:searchOptions range:albumNameRange];
        if (foundRange.length > 0)
        {
            [self.searchResults addObject:albumCollection];
        }
    }
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
