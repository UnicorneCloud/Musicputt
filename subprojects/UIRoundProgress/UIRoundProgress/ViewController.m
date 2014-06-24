//
//  ViewController.m
//  UIRoundProgress
//
//  Created by Eric Pinet on 2014-06-24.
//  Copyright (c) 2014 Eric Pinet. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    progress = 0.0;
    
    
	self.progressView.tintColor = [UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0];
	self.progressView.borderWidth = 2.0;
	self.progressView.lineWidth = 2.0;
	//self.progressView.fillOnTouch = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)increaseOneProgress:(id)sender
{
    progress = progress + 0.1;
    if (progress>1.1) {
        progress = 0.0;
    }
    [_progressView setProgress:progress animated:TRUE];
}

@end
