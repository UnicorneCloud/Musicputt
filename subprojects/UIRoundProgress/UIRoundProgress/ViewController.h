//
//  ViewController.h
//  UIRoundProgress
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"

@interface ViewController : UIViewController
{
    float progress;
}


@property (nonatomic, weak) IBOutlet UAProgressView *progressView;

- (IBAction)increaseOneProgress:(id)sender;



@end

