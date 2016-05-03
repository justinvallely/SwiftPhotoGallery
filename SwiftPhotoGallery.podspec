#
# Be sure to run `pod lib lint SwiftPhotoGallery.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftPhotoGallery"
  s.version          = "2.0.4"
  s.summary          = "Photo gallery for iOS written in Swift"
  s.description      = <<-DESC
                        "Photo gallery for iOS written in Swift. Photos can be panned and zoomed. Includes a customizable page indicator, support for any orientation, and supports images of varying sizes. Includes unit tests."
                       DESC

  s.homepage         = "https://github.com/Inspirato/SwiftPhotoGallery"
  s.license          = 'GNU'
  s.author           = { "Justin Vallely" => "jvallely@inspirato.com" }
  s.source           = { :git => "https://github.com/Inspirato/SwiftPhotoGallery.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SwiftPhotoGallery' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit', 'Foundation'
end
