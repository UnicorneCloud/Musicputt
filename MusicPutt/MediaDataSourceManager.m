//
//  IPodLibraryManager.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-06-17.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "MediaDataSourceManager.h"


@interface MediaDataSourceManager ()
{
//    id              delegate;       // delegate of the IPodLibraryManager
    MPMediaQuery*   everything;     // result of current query
    
}
@end

@implementation MediaDataSourceManager

-(void) StartLoad
{
    [self loadIPodLibrary];
}


-(void) loadIPodLibrary
{
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Starting ...");
    
    [self _iPodWillChangeValue];
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Delegate call completed ...");
    
    // Specify a media query; this one matches the entire iPod library because it
    // does not contain a media property predicate
    everything = [[MPMediaQuery alloc] init];
    
    // Configure the media query to group its media items; here, grouped by artist
    [everything setGroupingType: MPMediaGroupingArtist];
    
    // Obtain the media item collections from the query
    NSArray *collections = [everything collections];
    
    MPMediaItemCollection *artists = nil;
    
    for (int i=0; i<collections.count; i++) {
        
        MPMediaItem *item = nil;
        artists = [collections objectAtIndex:i];
        
        for (int y=0; y<artists.items.count; y++) {
            item = [artists.items objectAtIndex:y];
            NSLog(@"%@, %@, %@",  [item valueForProperty:MPMediaItemPropertyArtist],
                  [item valueForProperty:MPMediaItemPropertyAlbumTitle],
                  [item valueForProperty:MPMediaItemPropertyTitle]);
        } // end loop items
    } // end loop artists
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Finished");
}

////////////////////////////////////////////
#pragma mark - MediaDataSource
-(void) _iPodWillChangeValue
{
    //NSNotification *notification;
    
    //notification = [NSNotification notificationWithName:MediaDataSourceWillChangeValueNotification object:self];
    
    if ([self.dataSource respondsToSelector:@selector(mediaWillLoad)]) {
        [self.dataSource mediaWillLoad];
    }
    
    //[[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
