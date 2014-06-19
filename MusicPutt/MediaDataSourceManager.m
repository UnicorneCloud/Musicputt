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
    MPMediaQuery*   everything;     // result of current query
    NSUInteger      nbSection;      // nb section
    NSUInteger      nbMedia;        // nb media
}
@end

@implementation MediaDataSourceManager

-(BOOL) loadMediaByGroup;
{
    BOOL retval = false;
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Starting ...");
    
    [self _iPodWillChangeValue];
    
    nbMedia = 0;
    nbSection = 0;
    
    // Specify a media query; this one matches the entire iPod library because it
    // does not contain a media property predicate
    everything = [[MPMediaQuery alloc] init];
    
    // Configure the media query to group its media items; here, grouped by artist, album, playlist
    //if ( [groupByType == GroupByType.MediaDataSourceLoadMediaGroupByAlbumArtist] )
    //{
        [everything setGroupingType: MPMediaGroupingAlbum];
        
        // Obtain the media item collections from the query
        NSArray *collections = [everything collections];
        
        //MPMediaItemCollection *album = nil;
        
        nbMedia = collections.count;
        nbSection = 1;
        
        /*
        for (int i=0; i<collections.count; i++) {
            
            MPMediaItem *item = nil;
            album = [collections objectAtIndex:i];
            
            for (int y=0; y<album.items.count; y++) {
                item = [album.items objectAtIndex:y];
                NSLog(@"%@, %@, %@",    [item valueForProperty:MPMediaItemPropertyArtist],
                                        [item valueForProperty:MPMediaItemPropertyAlbumTitle],
                                        [item valueForProperty:MPMediaItemPropertyTitle]);
                
            } // end loop items
        } // end loop artists
        */
        retval = true;
/*
    }
    else if( [MediaGroupBy isEqualToString:MediaDataSourceLoadMediaGroupByPlaylist] )
    {
        [everything setGroupingType: MPMediaGroupingPlaylist];
    }
    else if ( [MediaGroupBy isEqualToString:MediaDataSourceLoadMediaGroupByArtist] )
    {
        [everything setGroupingType: MPMediaGroupingArtist];
        
    }
    else
    {
        NSLog(@" %s - %@ %@ %@\n", __PRETTY_FUNCTION__, @"Group by", MediaGroupBy, @"not supported ...");
    }
*/
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"Finished");
    return retval;
}

-(NSUInteger) getNbSection
{
    return nbSection;
}

-(NSUInteger) getNbMedia
{
    return nbMedia;
}

-(UIImage*) getMediaImage:(NSUInteger) media :(CGSize) size
{
    UIImage *retimage = nil;
    
    // Obtain the media item collections from the query
    NSArray *collections = [everything collections];
    
    MPMediaItemCollection *album = nil;
    album = [collections objectAtIndex:media];
    
    MPMediaItem *item = nil;
    item = [album.items objectAtIndex:0];
    
    //NSLog(@" %s - Item : %@, %@, %@\n", __PRETTY_FUNCTION__,    [item valueForProperty:MPMediaItemPropertyArtist],
    //                                                            [item valueForProperty:MPMediaItemPropertyAlbumTitle],
    //                                                            [item valueForProperty:MPMediaItemPropertyTitle]);

    
    MPMediaItemArtwork *artwork = [item valueForProperty:MPMediaItemPropertyArtwork];
    
    if (artwork) {
        retimage = [artwork imageWithSize:size];
    }
    
    return retimage;
}



-(void) logMediaInformation:(NSInteger) media
{
    // Obtain the media item collections from the query
    NSArray *collections = [everything collections];
    
    MPMediaItemCollection *album = nil;
    album = [collections objectAtIndex:media];
    
    MPMediaItem *item = nil;
    item = [album.items objectAtIndex:0];
    
    NSLog(@" %s - Item : %@, %@, %@\n", __PRETTY_FUNCTION__,    [item valueForProperty:MPMediaItemPropertyArtist],
          [item valueForProperty:MPMediaItemPropertyAlbumTitle],
          [item valueForProperty:MPMediaItemPropertyTitle]);

}


////////////////////////////////////////////
#pragma mark - MediaDataSource
-(void) _iPodWillChangeValue
{
    if ([self.dataSource respondsToSelector:@selector(mediaWillLoad)]) {
        [self.dataSource mediaWillLoad];
    }
}

@end
