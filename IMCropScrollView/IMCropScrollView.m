//
//  IMCropScrollView.m
//  crop
//
//  Created by Martin Kluska on 19.02.13.
//  Copyright (c) 2013 iMakers, s.r.o. All rights reserved.
//

#import "UIImage+Scale.h"
#import "IMCropScrollView.h"
#import <QuartzCore/QuartzCore.h>

#define rad(angle) ((angle) / 180.0 * M_PI)
#define angle(radians) ((radians) * (180.0 / M_PI))

@implementation IMCropScrollView

@synthesize rotationEnabled = _rotationEnabled;

@synthesize operationQueue  = _operationQueue;

+ (UIImage*)cropImage:(UIImage*)image forScrollViewFrame:(CGRect)frame andZoomScale:(float)zoomScale andContentOffset:(CGPoint)contentOffset andBarColor:(UIColor*)color {
    
    //NSLog(@"IMCropScrollView: Scale:        %f",zoomScale);
    
    @autoreleasepool {
        
        CGRect smallImageSize   = [IMCropScrollView getImageSize:image inBounds:frame withImageOffset:YES];
        
        BOOL drawBarsOnNoZoom   = NO;
        if (color != nil) {
            if (frame.size.width != smallImageSize.size.width || frame.size.height != smallImageSize.size.height) {
                drawBarsOnNoZoom= YES;
            }
        }
        
        // fix when scale and offset is not setted and the image should be filled to frame.
        
        BOOL imageIsWithOffset      = CGPointEqualToPoint(smallImageSize.origin, CGPointZero);
        
        if (zoomScale != 1 || drawBarsOnNoZoom) {
            
            CGRect visibleRect  = [IMCropScrollView getCropedImageRectAtScale:zoomScale andCropFrame:frame andImageSize:image.size withContentOffset:contentOffset];
            
            CGAffineTransform rectTransform;
            
            //NSLog(@"IMCropScrollView: Orientation %d",image.imageOrientation);
            
            switch (image.imageOrientation)
            {
                case UIImageOrientationLeft:
                    rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
                    break;
                case UIImageOrientationRight:
                    rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
                    break;
                case UIImageOrientationDown:
                    rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
                    break;
                default:
                    rectTransform = CGAffineTransformIdentity;
            };
            
            visibleRect = CGRectApplyAffineTransform(visibleRect,CGAffineTransformScale(rectTransform, image.scale, image.scale));
            
            //NSLog(@"IMCropScrollView: Original:     %f %f",image.size.width,image.size.height);
            //NSLog(@"IMCropScrollView: Rect:         %f %f",visibleRect.size.width,visibleRect.size.height);
            //NSLog(@"IMCropScrollView: Offset:       %f %f",visibleRect.origin.x,visibleRect.origin.y);
            
            
            
            CGImageRef cr               = CGImageCreateWithImageInRect([image CGImage], visibleRect);
            
            UIImage *img    = nil;
            
            // image offset is set, maybe we need to draw bars to fill image area
            if (!imageIsWithOffset && color) {
                //NSLog(@"IMCropScrollView: New image:    %zu %zu", CGImageGetWidth(cr),CGImageGetHeight(cr));
                
                float imgWidth      = CGImageGetWidth(cr);
                float imgHeight     = CGImageGetHeight(cr);
                
                if (image.size.width < image.size.height) {
                    imgWidth        = imgHeight;
                    imgHeight       = CGImageGetWidth(cr);
                } else {
                    imgWidth        = CGImageGetWidth(cr);
                }
                
                // DRAW BLACK BARS if image size is not equal as desired
                if (visibleRect.size.width > imgWidth || visibleRect.size.height > imgHeight) {
                    
                    CGRect imageRect            = CGRectMake(0, 0, visibleRect.size.width, visibleRect.size.height);
                    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
                    CGContextRef context        = CGBitmapContextCreate(NULL, visibleRect.size.width, visibleRect.size.height, 8, 0, colorSpace, kCGBitmapAlphaInfoMask);
                    
                    CGContextSetFillColorWithColor(context, [color CGColor]);
                    CGContextFillRect(context, imageRect);
                    CGContextDrawImage(context, CGRectMake((visibleRect.size.width - CGImageGetWidth(cr)) / 2, (visibleRect.size.height - CGImageGetHeight(cr)) / 2, CGImageGetWidth(cr), CGImageGetHeight(cr)), cr);
                    
                    cr                          = CGBitmapContextCreateImage(context);
                    
                    CGColorSpaceRelease(colorSpace);
                    CGContextRelease(context);
                }
            }
            
            img                 = [[UIImage alloc] initWithCGImage:cr scale:[image scale] orientation:[image imageOrientation]];
            image   = nil;
            //NSLog(@"IMCropScrollView: New image:    %f %f",img.size.width,img.size.height);
            CGImageRelease(cr);
            return img;
            
        } else return image;
        
    }
    
    
    
}

+ (CGRect)getCropedImageRectAtScale:(float)scale andCropFrame:(CGRect)frame andImageSize:(CGSize)imageSize  withContentOffset:(CGPoint)contentOffset {
    
    CGRect visibleRect;
    
    scale     = (1.0f / scale);
    
    //NSLog(@"Size  %@",NSStringFromCGSize(imageSize));
    // NSLog(@"Frame  %@",NSStringFromCGRect(frame));
    
    // calculate real image size after scale and the offsets
    
    float width                 = frame.size.width * scale;
    float height                = frame.size.height * scale;
    
    visibleRect.size.width      = width;
    visibleRect.size.height     = height;
    visibleRect.origin.y        = contentOffset.y * scale;
    visibleRect.origin.x        = contentOffset.x * scale;
    
    
    float _imageScale   = 0;
    NSLog(@"Image Size: %@",NSStringFromCGSize(imageSize));
    NSLog(@"Height %f",(frame.size.height / imageSize.height));
    NSLog(@"Width %f",(frame.size.width / imageSize.width));
    
    float imageScaleByHeight    = (frame.size.height / imageSize.height);
    float imageScaleByWidth     = (frame.size.width / imageSize.width);
    
    if ((frame.size.width == frame.size.height && imageSize.height > imageSize.width) || imageScaleByHeight < imageScaleByWidth) {
        NSLog(@"Croping mode by height");
        _imageScale     = 1/imageScaleByHeight;
    } else {
        _imageScale     = 1/imageScaleByWidth;
        NSLog(@"Croping mode by width");
    }
    
    CGSize CropinViewSize = CGSizeMake((visibleRect.size.width*(_imageScale)),(visibleRect.size.height*(_imageScale)));
    
    
    if((NSInteger)CropinViewSize.width % 2 == 1)
    {
        CropinViewSize.width = ceil(CropinViewSize.width);
    }
    if((NSInteger)CropinViewSize.height % 2 == 1)
    {
        CropinViewSize.height = ceil(CropinViewSize.height);
    }
    
    NSLog(@"Cropping size %@",NSStringFromCGSize(CropinViewSize));
    
    return CGRectMake((NSInteger)(visibleRect.origin.x * (_imageScale)) ,(NSInteger)( visibleRect.origin.y * (_imageScale)), (NSInteger)CropinViewSize.width,(NSInteger)CropinViewSize.height);
}
+ (CGRect)getImageSize:(UIImage*)image
              inBounds:(CGRect)bounds
       withImageOffset:(BOOL)getImageOffset {
    
    return [IMCropScrollView getImageSizeFromSize:image.size
                                         inBounds:bounds
                                  withImageOffset:getImageOffset];
}
+ (CGRect)getImageSizeFromSize:(CGSize)size
                      inBounds:(CGRect)bounds
               withImageOffset:(BOOL)getImageOffset {
    
    float height    =   size.height;
    float width     =   size.width;
    
    
    // resize image to fix max scrollview bounds
    if (width > bounds.size.width) {
        width   = bounds.size.width;
        height  = bounds.size.width / (size.width / size.height);
    }
    
    if (height > bounds.size.height) {
        height  = bounds.size.height;
        width   = bounds.size.height / (size.height / size.width);
    }
    
    CGRect imageSize    = CGRectMake(0, 0, width, height);
    
    if (getImageOffset) {
        
        // Make image offset (image is not in same ratio) to fix container calculations
        imageSize.origin.x     = (bounds.size.width - width);
        imageSize.origin.y     = (bounds.size.height - height);
        
    }
    return imageSize;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    _zoomContainer  = [[UIView alloc] initWithFrame:self.bounds];
    [_zoomContainer setAutoresizingMask:UIViewAutoresizingNone];
    
    [self addSubview:_zoomContainer];
    
    _imageView  = [[UIImageView alloc] initWithFrame:self.bounds];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setAutoresizingMask:UIViewAutoresizingNone];
    
    [_zoomContainer addSubview:_imageView];
    
    _resizeScrollViewToImage    = NO;
    _imageCropOffsetX           = 0;
    _imageCropOffsetY           = 0;
    
    _fillRectWithColor          = YES;
    
    _fillColor                  = [UIColor blackColor];
    _rotateDegrees              = 0;
    
    [self setMinimumZoomScale:1.0];
    [self setMaximumZoomScale:2.0];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
}

- (void)setRotationEnabled:(BOOL)rotationEnabled {
    if (rotationGestureRecognizer) {
        [rotationGestureRecognizer setEnabled:rotationEnabled];
    } else if (rotationEnabled) {
        rotationGestureRecognizer   = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
        [rotationGestureRecognizer setDelegate:self];
        [self addGestureRecognizer:rotationGestureRecognizer];
    }
    
    _rotationEnabled     = rotationEnabled;
}

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        // Queue in background
        _operationQueue     = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return _operationQueue;
}

#pragma mark - Crop image

- (UIImage*)croppedImage {
    @autoreleasepool {
        CGRect bounds           = self.bounds;
        CGPoint offset          = self.contentOffset;
        UIColor *fillColor      = nil;
        
        UIImage *image          = self.imageView.image;
        
        if (_fillRectWithColor) {
            fillColor   = self.fillColor;
        }
        // turn off the deacleretation
        self.scrollEnabled = NO;
        self.scrollEnabled = YES;
        
        if ([self isRotated]) {
            image   = [image rotateToDegrees:_rotateDegrees];
        }
        
        // CROP THE IMAGE
        return [IMCropScrollView cropImage:image forScrollViewFrame:bounds andZoomScale:self.zoomScale andContentOffset:offset andBarColor:fillColor];
    }
}

- (NSOperationQueue*)croppedImageWithBlock:(void(^)(UIImage *image))block {
    __weak typeof(self) weakSelf = self;
    
    [[self operationQueue] addOperationWithBlock:^{
        __block UIImage *image;
        
        if (weakSelf) {
            image  = [weakSelf croppedImage];
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image);
                image   = nil;
            });
        }
    }];
    
    return [self operationQueue];
}


#pragma mark Image

- (void)setImage:(UIImage*)image {
    [self setDelegate:self];
    
    [self.imageView setImage:image];
    
    [self fixToImageSize];
    [self centerImage];
}

- (void)setImageWithNoFix:(UIImage*)image {
    [self setDelegate:self];
    [self.imageView setImage:image];
}


#pragma mark - ImageView

- (void)centerImage {
    
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    
    self.zoomContainer.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                            self.contentSize.height * 0.5 + offsetY);
}

- (void)fixToImageSize {
    [self centerImage];
    [self fixToImageSize:YES];
}

- (void)fixToImageSize:(BOOL)setZoomToMinZoom {
    CGRect imageSize    = [IMCropScrollView getImageSize:self.imageView.image inBounds:self.bounds withImageOffset:NO];
    
    [self fixImageToSize:imageSize.size];
    
    if (_resizeScrollViewToImage) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, imageSize.size.width, imageSize.size.height)];
    } else if (!self.fillRectWithColor){
        [self fixImageZoom:setZoomToMinZoom andSize:imageSize.size];
    }
}

- (void)fixImageToSize:(CGSize)imageSize {
    
    [self.zoomContainer setFrame:CGRectMake(0,0, imageSize.width, imageSize.height)];
    [self.imageView setFrame:CGRectMake(0,0, imageSize.width, imageSize.height)];
}

- (void)fixImageZoom:(BOOL)setZoomToMinZoom  andSize:(CGSize)imageSize {
    float zoomOnHeight  = self.bounds.size.height / imageSize.height;
    float zoomOnWidth   = self.bounds.size.width / imageSize.width;
    float zoom          = 1;
    
    if (zoomOnHeight < 0) {
        zoomOnHeight *= -1;
    }
    
    if (zoomOnWidth < 0) {
        zoomOnWidth *= -1;
    }
    
    if (zoomOnHeight > zoomOnWidth) {
        zoom            = zoomOnHeight;
    } else {
        zoom            = zoomOnWidth;
    }
    
    if (zoom < 1) {
        zoom    = 1;
    }
    [self setMinimumZoomScale:zoom];
    
    if (setZoomToMinZoom && self.zoomScale < zoom) {
        [self setZoomScale:zoom];
    }
}

#pragma mark - Rotation

- (void)rotateImageToRight {
    if (_rotateDegrees >= 360) {
        _rotateDegrees  = 0;
    }
    _rotateDegrees += 90;
    
    [self rotateImageToDegrees:_rotateDegrees andAnimated:YES];
}

- (void)rotateImageToDegrees:(float)degreess
                 andAnimated:(BOOL)animated {
    
    
    _rotateDegrees  = degreess;
    _animating      = YES;
    
    //NSLog(@"Rotated to %f",_rotateDegrees);
    
    CGAffineTransform transform     = CGAffineTransformMakeRotation(rad(_rotateDegrees));
    
    // prepare the image view for rotation
    [self setMinimumZoomScale:1.0];
    [self setZoomScale:1.0 animated:animated];
    [self setContentOffset:CGPointZero animated:NO];
    
    CGSize rotatedSize;
    
    // rotate the size
    if (_rotateDegrees == 0 || _rotateDegrees == 180 || _rotateDegrees == 360) {
        rotatedSize = CGSizeMake(self.imageView.image.size.width, self.imageView.image.size.height);
    } else {
        rotatedSize = CGSizeMake(self.imageView.image.size.height, self.imageView.image.size.width);
    }
    
    // get the rotated image
    rotatedSize     = [IMCropScrollView getImageSizeFromSize:rotatedSize inBounds:self.bounds withImageOffset:NO].size;
    
    void(^onAnimation)(void) = ^(void){
        [_imageView setTransform:transform];
        [self fixImageZoom:NO andSize:rotatedSize];
        [self fixImageToSize:rotatedSize];
        [self setZoomScale:[self minimumZoomScale] animated:animated];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.50
                         animations:onAnimation
                         completion:^(BOOL finished) {
                             if (finished) {
                                 _animating     = NO;
                             }
                         }];
    } else {
        onAnimation();
        _animating  = NO;
    }
    
}

- (BOOL)isRotated {
    return _rotateDegrees != 0 && _rotateDegrees != 360;
}

- (void)rotationGesture:(UIRotationGestureRecognizer*)gesture {
    if([gesture state] == UIGestureRecognizerStateEnded) {
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [gesture rotation]);
    
    CGAffineTransform currentTransform = [self imageView].transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [[self imageView] setTransform:newTransform];
    
    _lastRotation = [gesture rotation];
    
    _rotateDegrees = angle(atan2(newTransform.b, newTransform.a));
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.zoomContainer;
}

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView {
    [self centerImage];
    
    if (self.onZoom) {
        self.onZoom(self);
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
