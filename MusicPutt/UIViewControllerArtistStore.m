//
//  UIViewControllerArtistStore.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-08-02.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UIViewControllerArtistStore.h"

#import "UIViewControllerStoreAlbum.h"
#import "UIViewControllerStoreSongs.h"

@interface UIViewControllerArtistStore ()
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


/**
 *  ScrollView
 */
@property (weak, nonatomic) IBOutlet UIScrollView*       mainScrollView;


@end

@implementation UIViewControllerArtistStore

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
    
    // setup title
    [self setTitle:@"Store"];
    
    // setup segmented control menu
    [_segcontrol addTarget:self
                   action:@selector(menuPressed:)
         forControlEvents:UIControlEventValueChanged];
    
    // setup children view controller
    CGRect framealbum = _pageview.frame;
    framealbum.origin.x = 0;
    framealbum.origin.y = 0;
    
    CGRect framesong = _pageview.frame;
    framesong.origin.x = 0;
    framesong.origin.y = 0;
    
    storealbum = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreAlbum"];
    [storealbum setStoreArtistId:_storeArtistId];
    storealbum.view.frame = framealbum;
    [self addChildViewController:storealbum];
    [_pageview addSubview:storealbum.view];
    
    storesongs = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreSongs"];
    [storesongs setStoreArtistId:_storeArtistId];
    storesongs.view.frame = framesong;
    [self addChildViewController:storesongs];
    [_pageview addSubview:storesongs.view];
    
    // setup tableview
    scrollView = _mainScrollView;
    
    [self displayView:@"Albums"];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [storealbum stopPlaying];
    [storesongs stopPlaying];
    
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
        storealbum.view.hidden = FALSE;
        storesongs.view.hidden = TRUE;
    }
    else{
        storealbum.view.hidden = TRUE;
        storesongs.view.hidden = FALSE;
    }
    [storealbum stopPlaying];
    [storesongs stopPlaying];
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
