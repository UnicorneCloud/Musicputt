//
//  UIViewControllerStoreFeature
//
//  Created by Eric Pinet on 2014-07-01.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerFeature.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIViewControllerPlaylist.h"
#import "UITableViewCellFeature.h"
#import "AppDelegate.h"

@interface UIViewControllerFeature ()  <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    UIBarButtonItem* editButton;
}

@property (weak, nonatomic) IBOutlet UITableView*            tableView;
@property AppDelegate* del;

@end

@implementation UIViewControllerFeature

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
    [self setTitle:@"Feature"];
    
    // setup tableview
    toolbarTableView = _tableView;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AMWaveViewController

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCellFeature*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellFeature* cell = [tableView dequeueReusableCellWithIdentifier:@"CellFeature"];
    return cell;
}


#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
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
