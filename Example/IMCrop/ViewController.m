//
//  ViewController.m
//  crop
//
//  Created by Martin Kluska on 19.02.13.
//  Copyright (c) 2013 iMakers, s.r.o. All rights reserved.
//

#import "ViewController.h"

#import "IMCropScrollView.h"
#import "IMCropOverlay.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.scrollView setFillRectWithColor:NO];
    [self.scrollView setImage:[UIImage imageNamed:@"IMG_0529.JPG"]];
    [self.scrollView setClipsToBounds:NO];
    
    [[self cropOverlay] setCropScrollView:[self scrollView]];
    [[self cropOverlay] setNeedsDisplay];
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
}


- (IBAction)generate:(id)sender {
    
    [[self scrollView] croppedImageWithBlock:^(UIImage *image) {
        [self.preview setImage:image];
    }];
}

- (IBAction)rotateImage:(id)sender {
    [[self scrollView] rotateImageToRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
