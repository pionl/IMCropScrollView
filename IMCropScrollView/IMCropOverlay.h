//
//  PhotoEditImageCropOverlay.h
//  capturio
//
//  Created by Martin Kluska on 26.06.13.
//  Copyright (c) 2013 iMakers, s.r.o. - Maritn Kluska. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMCropScrollView;

@interface IMCropOverlay : UIView

/**
 *  When connected, it will draw mask in the cropScrollView frame
 */
@property (nonatomic, weak) IMCropScrollView *cropScrollView;

/**
 *  Opacity for current color
 *  @default 0.6
 */
@property (nonatomic) float opacity;

/**
 *  A fill color around the scrollView
 *  @default [UIColor colorWithWhite:0.0 alpha:0.5]
 */
@property (nonatomic, strong) UIColor *fillColor;

/**
 *  Border color
 *  @default whiteColor
 */
@property (nonatomic, strong) UIColor *borderColor;
/**
 *  Border width
 *  @default 2.0
 */
@property (nonatomic) float borderWidth;
/**
 *  Current radius for border
 * 	@default 2.0
 */
@property (nonatomic) float cornerRadius;

@end
