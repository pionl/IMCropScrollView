# IMCropScrollView

[![Version](https://img.shields.io/cocoapods/v/IMCrop.svg?style=flat)](http://cocoadocs.org/docsets/IMCrop)
[![License](https://img.shields.io/cocoapods/l/IMCrop.svg?style=flat)](http://cocoadocs.org/docsets/IMCrop)
[![Platform](https://img.shields.io/cocoapods/p/IMCrop.svg?style=flat)](http://cocoadocs.org/docsets/IMCrop)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

This class supports displaying a image in scrollView with croping option. The user can move the image to desired crop and rotate. For rotation 
we use UIImage+Scale with fixOrientation (photos from camera).

You can use in any view, just set the correct frame (in the desired aspect ratio) and after calling croppedImage you will get the desired image.

    [[self scrollView] croppedImageWithBlock:^(UIImage *image) {
        [self.preview setImage:image];
    }];

You can also draw a overlay over the scrollView and draw image out of the bounds of scroll view

    [self.scrollView setClipsToBounds:NO];

    [[self cropOverlay] setCropScrollView:[self scrollView]];
    [[self cropOverlay] setNeedsDisplay];


The scrollView and overlay can be created from nib or code as needed. The autosize mask doens't work correctly (future update?).

If you don't want to use current scrollView, you can only use the cropping option by:

    + (UIImage*)cropImage:(UIImage*)image forScrollViewFrame:(CGRect)frame andZoomScale:(float)zoomScale andContentOffset:(CGPoint)contentOffset andBarColor:(UIColor*)color

## Requirements

iOS5+

## Installation

IMCrop is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "IMCrop"

## Author

Martin Kluska, martin.kluska@imakers.cz

## License

IMCrop is available under the MIT license. See the LICENSE file for more info.

