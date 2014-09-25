//
//  PhotoEditImageCropOverlay.m
//  capturio
//
//  Created by Martin Kluska on 26.06.13.
//  Copyright (c) 2013 iMakers, s.r.o. - Maritn Kluska. All rights reserved.
//

#import "IMCropOverlay.h"

#import "IMCropScrollView.h"

@implementation IMCropOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.opaque                 = NO;
    self.backgroundColor        = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    _opacity        = 0.6;
    _fillColor      = [UIColor colorWithWhite:0.0 alpha:0.5];
    _borderColor    = [UIColor whiteColor];
    _borderWidth    = 2.0;
    _cornerRadius   = 2.0;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Start by filling the area with the blue color
    [[self fillColor] setFill];
    UIRectFill( rect );
    
     // Assume that there's an ivar somewhere called holeRect of type CGRect
     // We could just fill holeRect, but it's more efficient to only fill the
     // area we're being asked to draw.
    CGRect holeRectIntersection = CGRectIntersection( self.cropScrollView.frame, rect );
     
    [[UIColor clearColor] setFill];
    UIRectFill( holeRectIntersection );
    
    // preapre border rect
    
    float offset    = 2.0f;
    holeRectIntersection.size.width     += offset;
    holeRectIntersection.size.height    += offset;
    holeRectIntersection.origin.x       -= 1.0f;
    holeRectIntersection.origin.y       -= 1.0f;
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:holeRectIntersection cornerRadius:[self cornerRadius]];
    [rectPath setLineWidth:[self borderWidth]];
    
    if ([self borderWidth] > 0){
        [[self borderColor] setStroke];
    }
    
    [rectPath strokeWithBlendMode:kCGBlendModeNormal alpha:[self opacity]];
}

@end
