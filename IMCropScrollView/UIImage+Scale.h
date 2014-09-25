//
//  UIImage+Scale.h
//  Capturio
//
//  Created by Martin Kluska on 01.02.13.
//  Copyright (c) 2013 iMakers, s.r.o. - Maritn Kluska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage*)cropToSize:(CGSize)size;
- (UIImage*)resizeToSize:(CGSize)size;
- (UIImage*)resizeToSize:(CGSize)size andFromMin:(BOOL)fromMin;
- (UIImage*)resizeScreenSize;

- (UIImage*)rotateToDegrees:(float)degrees;

- (BOOL)isOrientationPortrait;

- (UIImage *)fixOrientation;

@end
