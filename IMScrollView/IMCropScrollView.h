//
//  IMCropScrollView.h
//  crop
//
//  This will not handle big images 4MPx >, it can crash. You should resize the image.
//
//  Created by Martin Kluska on 19.02.13.
//  Copyright (c) 2013 iMakers, s.r.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMCropScrollView : UIScrollView <UIScrollViewDelegate> {
    float _imageCropOffsetX;
    float _imageCropOffsetY;
}
/**
 *  Operation queue for
 */
@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;

@property (nonatomic, strong, readonly) UIView          *zoomContainer;
@property (nonatomic, strong, readonly) UIImageView     *imageView;

/**
 * Defines, if the scrollview should be resized to same ratio size as image
 */
@property (nonatomic) BOOL                              resizeScrollViewToImage;

/**
 *  Determines if left rectangle should be drawed with color. This is set to YES.
 *  if set in NO, it will zoom the image to fill the scrollview
 */
@property (nonatomic) BOOL                              fillRectWithColor;
/**
 *  If fillRectWithColor is defined, this color will be used
 */
@property (nonatomic, strong) UIColor                   *fillColor;

/**
 *  On zoom callback
 */
@property (nonatomic, strong) void(^onZoom)(IMCropScrollView *scrollView);


/**
 *  Crops image in given frame, zoom scale for cropping and offset. If color defined, it will fill
 *  empty spaces if image is smaller (in aspect size) then desired cropping area.
 *
 *  @param image            image to crop
 *  @param frame            frame of the cropping area. This will only use for aspect cropping.
 *  @param zoomScale        zoom scale in given frame
 *  @param contentOffset    contentOffset for top left cropping
 *  @param color            optional color for black bars if needed.
 *
 *  @return UIImage*
 */
+ (UIImage*)cropImage:(UIImage*)image
   forScrollViewFrame:(CGRect)frame
         andZoomScale:(float)zoomScale
     andContentOffset:(CGPoint)contentOffset
          andBarColor:(UIColor*)color;

/**
 *  Calculates the correct rectangle for image
 *
 *  @param scale          image to be croped
 *  @param frame
 *  @param imageSize
 *  @param contentOffset
 *
 *  @return CGRect
 */
+ (CGRect)getCropedImageRectAtScale:(float)scale
                       andCropFrame:(CGRect)frame
                       andImageSize:(CGSize)imageSize
                  withContentOffset:(CGPoint)contentOffset;

/**
 *  Calculates correct image size for given image and bounds of the scroll view with scroll view offset
 *
 *  @param image          image to be croped
 *  @param bounds         scrollview bounds
 *  @param getImageOffset scrollview offset
 *
 *  @return CGRect
 */
+ (CGRect)getImageSize:(UIImage*)image
              inBounds:(CGRect)bounds
       withImageOffset:(BOOL)getImageOffset;

/**
 *
 *
 *  @param size
 *  @param bounds
 *  @param getImageOffset
 *
 *  @return CGRect
 */
+ (CGRect)getImageSizeFromSize:(CGSize)size
                      inBounds:(CGRect)bounds
               withImageOffset:(BOOL)getImageOffset;


#pragma mark - Crop image

/**
 *  Returns croped image to current frame size
 *
 *  @return
 */
- (UIImage*)croppedImage;


/**
 *  Returns croped image in block (runs in operation queue), block
 *  is called in main thread
 *
 *  @param block (void(^)(UIImage *image))
 *
 *  @return NSOperationQueue*
 */
- (NSOperationQueue*)croppedImageWithBlock:(void(^)(UIImage *image))block;

#pragma mark Image

/**
 *  Sets image into the view. It will automatically fit the image to the scrollView
 *
 *  @param image
 */
- (void)setImage:(UIImage*)image;

/**
 *  Sets image without any logic.
 *
 *  @param image
 */
- (void)setImageWithNoFix:(UIImage*)image;


#pragma mark - ImageView
/**
 *  Centers image in the scrollView
 */
- (void)centerImage;

/**
 *  Zooms the image if resizeScrollViewToImage is NO.
 *  Changes the imageView and zoomContainer for correct size to fit
 *  scrollView bounds.
 */
- (void)fixToImageSize;

/**
 *  Zooms the image if resizeScrollViewToImage is NO.
 *  Changes the imageView and zoomContainer for correct size to fit
 *  scrollView bounds.
 *  @param setZoomToMinZoom
 */
- (void)fixToImageSize:(BOOL)setZoomToMinZoom;

/**
 *  Changes the imageView and zoomContainer for correct size to fit
 *  scrollView bounds.
 *
 *  @param imageSize
 */
- (void)fixImageToSize:(CGSize)imageSize;

/**
 *  Calculates correct zoomScale to fit image into the view.
 *
 *  @param setZoomToMinZoom
 *  @param imageSize
 */
- (void)fixImageZoom:(BOOL)setZoomToMinZoom
             andSize:(CGSize)imageSize;

#pragma mark - Rotation

/**
 *  Current rotation
 */
@property (nonatomic) float rotateDegrees;

/**
 *  Determines if the view is animating for rotation.
 */
@property (nonatomic, readonly) BOOL animating;

/**
 *  Rotates the image in right direction (+90deg)
 */
- (void)rotateImageToRight;

/**
 *  Rotates image into the given degrees with optional animation.
 *
 *  @param degreess
 *  @param animated
 */
- (void)rotateImageToDegrees:(float)degreess
                 andAnimated:(BOOL)animated;

/**
 *  Determines if the image was rotated.
 *
 *  @return
 */
- (BOOL)isRotated;
@end

@interface IMCropScrollView ()

- (void)setUp;


@end
