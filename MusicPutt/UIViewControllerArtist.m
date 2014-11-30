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

@interface UIViewControllerArtist ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    MPMediaQuery* everything;             // result of current query
    NSArray*      artists;
    NSMutableDictionary *artistDictionary;
}
@property AppDelegate* del;
@property (weak, nonatomic) IBOutlet UITableView*  tableView;
@property (nonatomic) NSMutableArray *searchResults;
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
    
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    
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
	if (tableView == self.searchDisplayController.searchResultsTableView)
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

    if (tableView == self.searchDisplayController.searchResultsTableView)
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

#pragma mark - Content Filtering

- (void)updateFilteredContentForArtist:(NSString *)artistName
{

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

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self updateFilteredContentForArtist:searchString];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //[self viewWillAppear:YES];
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

-(IBAction)toggleSearch:(id)sender
{
    // hide the search bar when it's showed
    if (self.tableView.bounds.origin.y == -64) {
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.frame.size.height-70, 1, 1) animated:YES];
    }
    else
    {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
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
