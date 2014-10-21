//
//  ViewController.h
//  crop
//
//  Created by Martin Kluska on 19.02.13.
//  Copyright (c) 2013 iMakers, s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMCropScrollView, IMCropOverlay;

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet IMCropOverlay *cropOverlay;
@property (strong, nonatomic) IBOutlet IMCropScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *preview;


- (IBAction)generate:(id)sender;
- (IBAction)rotateImage:(id)sender;

@end
