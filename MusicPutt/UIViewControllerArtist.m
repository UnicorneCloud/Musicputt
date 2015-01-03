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


@interface UIViewControllerArtist ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>
{
    MPMediaQuery* everything;             // result of current query
    NSArray*      artists;
    NSMutableDictionary *artistDictionary;
}
@property AppDelegate* del;
@property (weak, nonatomic) IBOutlet UITableView*  tableView;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic)UISearchController *searchController;
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
    scrollView = _tableView;
    
    // setup query artists
    everything = [MPMediaQuery artistsQuery];

    artists = [everything collections];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[artists count]];
    
    // scroll the search bar off-screen
    //[self hideSearchBar];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0, 44)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    /*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (self.searchController.active)
	{
        return [self.searchResults count];
    }
	else
	{
        return artists.count;
    }
}

- (UITableViewCellArtist*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellArtist* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellArtist"];

    if (self.searchController.active)
	{
        [cell setArtistItem: self.searchResults[indexPath.row] withDictionnary:artistDictionary];
    }
	else
	{
        [cell setArtistItem: artists[indexPath.row] withDictionnary:artistDictionary];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForArtist:(NSString *)artistName
{
    if ((artistName == nil) || [artistName length] == 0) {
        self.searchResults = [artists mutableCopy];
        return;
    }
    [self.searchResults removeAllObjects]; // First clear the filtered array.
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    for (MPMediaItemCollection *artistCollection in artists)
	{
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        MPMediaItem* artistRepresentativeItem = [(MPMediaItemCollection*)artistCollection representativeItem];
        NSString *name = [artistRepresentativeItem valueForProperty:MPMediaItemPropertyArtist];
        NSRange artistNameRange = NSMakeRange(0, name.length);
        NSRange foundRange = [name rangeOfString:artistName options:searchOptions range:artistNameRange];
        if (foundRange.length > 0)
        {
            [self.searchResults addObject:artistCollection];
        }
	}
}
#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    //if(searchString.length>0)
    //{
    [self updateFilteredContentForArtist:searchString];
    [self.tableView reloadData];
   // }
}
/*
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //[self viewWillAppear:YES];
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
}
*/
-(IBAction)toggleSearch:(id)sender
{
    // hide the search bar when it's showed
    NSLog(@"self.tableView.bounds.origin.y = %f", self.tableView.bounds.origin.y);
    
    if (self.tableView.bounds.origin.y == -64) {
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.frame.size.height-70, 1, 1) animated:YES];
    }
    else
    {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;                      // return NO to not become first responder
#pragma mark - UISearchBarDelegate Delegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"begin");
   //[self hideTabbar];
    //[self setupConstraintsWithSearchBar:searchBar];
    [self setupNavigationBar];
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"stoped");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"begin");
    
    [self setupNavigationBar];
    [self showCurrentPlayingToolbar];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"stoped");
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
