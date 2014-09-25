#
# Be sure to run `pod lib lint IMCrop.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "IMCropScrollView"
  s.version          = "1.0.1"
  s.summary          = "IMCropScrollView enables to make scrollView with crop option with rotation. You can also draw a overlay with opacity."
  s.description      = <<-DESC

                        This class supports displaying a image in scrollView with croping option. The user can move the image to desired crop and rotate. For rotation
                        we use UIImage+Scale with fixOrientation (photos from camera).
                       DESC
  s.homepage         = "https://github.com/pionl/IMCropScrollView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Martin Kluska" => "martin.kluska@imakers.cz" }
  s.source           = { :git => "https://github.com/pionl/IMCropScrollView.git", :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/pionl'

  s.platform     = :ios, '5.1'
  s.requires_arc = true

  s.source_files = 'IMCropScrollView/*.{h,m}'


  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit', 'QuartzCore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
