//
//  UITableViewControllerGender.m
//  MusicPutt
//
//  Created by Eric Pinet on 2014-10-18.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "UITableViewControllerGender.h"

#import "ITunesFeedsApi.h"
#import "PreferredGender.h"

@interface UITableViewControllerGender ()
{
    BOOL scrollViewIsDragging;
}


@end

@implementation UITableViewControllerGender

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 260.0)];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    self.tableView.editing = true;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    NSLog(@" %s - %@\n", __PRETTY_FUNCTION__, @"End");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 41;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row==0)
        cell.textLabel.text = GENRE_ALTERNATIVE_TXT;
    else if (indexPath.row == 1)
        cell.textLabel.text = GENRE_ANIME_TXT;
    else if (indexPath.row == 2)
        cell.textLabel.text = GENRE_BLUES_TXT;
    else if (indexPath.row == 3)
        cell.textLabel.text = GENRE_BRAZILIAN_TXT;
    else if (indexPath.row == 4)
        cell.textLabel.text = GENRE_CHILDRENSMUSIC_TXT;
    else if (indexPath.row == 5)
        cell.textLabel.text = GENRE_CHINESE_TXT;
    else if (indexPath.row == 6)
        cell.textLabel.text = GENRE_CHRISTIANGOSPEL_TXT;
    else if (indexPath.row == 7)
        cell.textLabel.text = GENRE_CLASSICAL_TXT;
    else if (indexPath.row == 8)
        cell.textLabel.text = GENRE_COMEDY_TXT;
    else if (indexPath.row == 9)
        cell.textLabel.text = GENRE_COUNTRY_TXT;
    else if (indexPath.row == 10)
        cell.textLabel.text = GENRE_DANCE_TXT;
    else if (indexPath.row == 11)
        cell.textLabel.text = GENRE_DISNEY_TXT;
    else if (indexPath.row == 12)
        cell.textLabel.text = GENRE_EASYLISTENING_TXT;
    else if (indexPath.row == 13)
        cell.textLabel.text = GENRE_ELECTRONIC_TXT;
    else if (indexPath.row == 14)
        cell.textLabel.text = GENRE_ENKA_TXT;
    else if (indexPath.row == 15)
        cell.textLabel.text = GENRE_FITNESSWORKOUT_TXT;
    else if (indexPath.row == 16)
        cell.textLabel.text = GENRE_FRENCHPOP_TXT;
    else if (indexPath.row == 17)
        cell.textLabel.text = GENRE_GERMANFOLK_TXT;
    else if (indexPath.row == 18)
        cell.textLabel.text = GENRE_GERMANPOP_TXT;
    else if (indexPath.row == 19)
        cell.textLabel.text = GENRE_HIPHOPRAP_TXT;
    else if (indexPath.row == 20)
        cell.textLabel.text = GENRE_HOLIDAY_TXT;
    else if (indexPath.row == 21)
        cell.textLabel.text = GENRE_INDIAN_TXT;
    else if (indexPath.row == 22)
        cell.textLabel.text = GENRE_INSTRUMENTAL_TXT;
    else if (indexPath.row == 23)
        cell.textLabel.text = GENRE_JPOP_TXT;
    else if (indexPath.row == 24)
        cell.textLabel.text = GENRE_JAZZ_TXT;
    else if (indexPath.row == 25)
        cell.textLabel.text = GENRE_KPOP_TXT;
    else if (indexPath.row == 26)
        cell.textLabel.text = GENRE_KARAOKE_TXT;
    else if (indexPath.row == 27)
        cell.textLabel.text = GENRE_KAYOKYOKU_TXT;
    else if (indexPath.row == 28)
        cell.textLabel.text = GENRE_KOREAN_TXT;
    else if (indexPath.row == 29)
        cell.textLabel.text = GENRE_LATINO_TXT;
    else if (indexPath.row == 30)
        cell.textLabel.text = GENRE_NEWAGE_TXT;
    else if (indexPath.row == 31)
        cell.textLabel.text = GENRE_OPERA_TXT;
    else if (indexPath.row == 32)
        cell.textLabel.text = GENRE_POP_TXT;
    else if (indexPath.row == 33)
        cell.textLabel.text = GENRE_RBSOUL_TXT;
    else if (indexPath.row == 34)
        cell.textLabel.text = GENRE_REGGAE_TXT;
    else if (indexPath.row == 35)
        cell.textLabel.text = GENRE_ROCK_TXT;
    else if (indexPath.row == 36)
        cell.textLabel.text = GENRE_SINGERSONGWRITER_TXT;
    else if (indexPath.row == 37)
        cell.textLabel.text = GENRE_SOUNDTRACK_TXT;
    else if (indexPath.row == 38)
        cell.textLabel.text = GENRE_SPOKENWORD_TXT;
    else if (indexPath.row == 39)
        cell.textLabel.text = GENRE_VOCAL_TXT;
    else if (indexPath.row == 40)
        cell.textLabel.text = GENRE_WORLD_TXT;
    
    // find gender
    PreferredGender* preferredGender = [PreferredGender MR_findFirstByAttribute:@"genderid" withValue:[NSNumber numberWithInteger:[self convertRowId2GenderId:indexPath.row]]];
    if (preferredGender!=nil) {
        // if preferred gender is found select the cell
        [cell setSelected:TRUE];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSLog(@" %s - %@ / %@\n", __PRETTY_FUNCTION__, cell.textLabel.text, @"selected");
    }
    else{
        [cell setSelected:FALSE];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSLog(@" %s - %@ / %@\n", __PRETTY_FUNCTION__, cell.textLabel.text, @"not selected");
    }
    
    if( self->scrollViewIsDragging && [[tableView indexPathForSelectedRow] isEqual:indexPath]) {
        [cell setHighlighted:YES animated:NO];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // witch gender we have to delete
    NSInteger genderid = 0;
    genderid = [self convertRowId2GenderId:indexPath.row];
    
    // find gender
    PreferredGender* preferredGender = [PreferredGender MR_findFirstByAttribute:@"genderid" withValue:[NSNumber numberWithInteger:genderid]];
    if (preferredGender!=nil) {
        [preferredGender MR_deleteEntity];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // find gender to add
    NSInteger genderid = 0;
    genderid = [self convertRowId2GenderId:indexPath.row];
    
    // add to preferred gender
    PreferredGender* preferredGender = [PreferredGender MR_createEntity];
    preferredGender.genderid = [NSNumber numberWithInteger:genderid];
}


- (NSInteger) convertRowId2GenderId: (NSInteger) rowId
{
    NSInteger genderid = 0;
    
    if (rowId==0)
        genderid = GENRE_ALTERNATIVE;
    else if (rowId == 1)
        genderid = GENRE_ANIME;
    else if (rowId == 2)
        genderid = GENRE_BLUES;
    else if (rowId == 3)
        genderid = GENRE_BRAZILIAN;
    else if (rowId == 4)
        genderid = GENRE_CHILDRENSMUSIC;
    else if (rowId == 5)
        genderid = GENRE_CHINESE;
    else if (rowId == 6)
        genderid = GENRE_CHRISTIANGOSPEL;
    else if (rowId == 7)
        genderid = GENRE_CLASSICAL;
    else if (rowId == 8)
        genderid = GENRE_COMEDY;
    else if (rowId == 9)
        genderid = GENRE_COUNTRY;
    else if (rowId == 10)
        genderid = GENRE_DANCE;
    else if (rowId == 11)
        genderid = GENRE_DISNEY;
    else if (rowId == 12)
        genderid = GENRE_EASYLISTENING;
    else if (rowId == 13)
        genderid = GENRE_ELECTRONIC;
    else if (rowId == 14)
        genderid = GENRE_ENKA;
    else if (rowId == 15)
        genderid = GENRE_FITNESSWORKOUT;
    else if (rowId == 16)
        genderid = GENRE_FRENCHPOP;
    else if (rowId == 17)
        genderid = GENRE_GERMANFOLK;
    else if (rowId == 18)
        genderid = GENRE_GERMANPOP;
    else if (rowId == 19)
        genderid = GENRE_HIPHOPRAP;
    else if (rowId == 20)
        genderid = GENRE_HOLIDAY;
    else if (rowId == 21)
        genderid = GENRE_INDIAN;
    else if (rowId == 22)
        genderid = GENRE_INSTRUMENTAL;
    else if (rowId == 23)
        genderid = GENRE_JPOP;
    else if (rowId == 24)
        genderid = GENRE_JAZZ;
    else if (rowId == 25)
        genderid = GENRE_KPOP;
    else if (rowId == 26)
        genderid = GENRE_KARAOKE;
    else if (rowId == 27)
        genderid = GENRE_KAYOKYOKU;
    else if (rowId == 28)
        genderid = GENRE_KOREAN;
    else if (rowId == 29)
        genderid = GENRE_LATINO;
    else if (rowId == 30)
        genderid = GENRE_NEWAGE;
    else if (rowId == 31)
        genderid = GENRE_OPERA;
    else if (rowId == 32)
        genderid = GENRE_POP;
    else if (rowId == 33)
        genderid = GENRE_RBSOUL;
    else if (rowId == 34)
        genderid = GENRE_REGGAE;
    else if (rowId == 35)
        genderid = GENRE_ROCK;
    else if (rowId == 36)
        genderid = GENRE_SINGERSONGWRITER;
    else if (rowId == 37)
        genderid = GENRE_SOUNDTRACK;
    else if (rowId == 38)
        genderid = GENRE_SPOKENWORD;
    else if (rowId == 39)
        genderid = GENRE_VOCAL;
    else if (rowId == 40)
        genderid = GENRE_WORLD;
    
    return genderid;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollview {
    self->scrollViewIsDragging = YES;
    
    if( [self.tableView indexPathForSelectedRow] ) {
        [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]] setHighlighted:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self->scrollViewIsDragging = NO;
    
    if( [self.tableView indexPathForSelectedRow] ) {
        [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]] setHighlighted:NO];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
