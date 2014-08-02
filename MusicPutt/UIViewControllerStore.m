//
//  UIViewControllerStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerStore.h"

#import "UIViewControllerStoreAlbum.h"
#import "UIViewControllerStoreSongs.h"

@interface UIViewControllerStore ()
{
    UIViewControllerStoreAlbum* storealbum;
    UIViewControllerStoreSongs* storesongs;
}

/**
 *  View that content page view controller for albums and songs.
 */
@property (weak, nonatomic) IBOutlet UIView*            pageview;

/**
 *  Control menu to display albums and songs view.
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl* segcontrol;




@end

@implementation UIViewControllerStore

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
    
    // setup segmented control menu
    [_segcontrol addTarget:self
                   action:@selector(menuPressed:)
         forControlEvents:UIControlEventValueChanged];
    
    // setup children view controller
    storealbum = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreAlbum"];
    [storealbum setStoreArtistId:_storeArtistId];
    [self addChildViewController:storealbum];
    [_pageview addSubview:storealbum.view];
    
    storesongs = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreSongs"];
    [storesongs setStoreArtistId:_storeArtistId];
    [self addChildViewController:storesongs];
    [_pageview addSubview:storesongs.view];
    
    
    [self displayView:@"Albums"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) menuPressed:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    [self displayView:[segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]]];
}


-(void)displayView:(NSString*)viewName
{
    if ([viewName isEqual:@"Albums"]) {
        storealbum.view.alpha = 1.0;
        storesongs.view.alpha = 0.0;
    }
    else{
        storealbum.view.alpha = 0.0;
        storesongs.view.alpha = 1.0;
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
