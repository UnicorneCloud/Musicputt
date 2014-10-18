//
//  DLAVAlertViewSelectGender.h
//  MusicPutt
//
//  Created by Eric Pinet on 2014-10-18.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "DLAVAlertView.h"

@interface DLAVAlertViewSelectGender : DLAVAlertView


#pragma mark - Initialization

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
