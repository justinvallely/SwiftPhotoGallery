
Pod::Spec.new do |s|
  s.name             = "SwiftPhotoGallery"
  s.version          = "3.4.1"
  s.summary          = "Photo gallery for iOS and tvOS written in Swift"
  s.description      = <<-DESC
                        "Photo gallery for iOS and tvOS written in Swift. Photos can be panned and zoomed (iOS). Includes a customizable page indicator, support for any orientation (iOS), and supports images of varying sizes. Includes unit tests."
                       DESC

  s.homepage         = "https://github.com/Inspirato/SwiftPhotoGallery"
  s.license          = 'Apache-2.0'
  s.author           = { "Justin Vallely" => "justinvallely@gmail.com" }
  s.source           = { :git => "https://github.com/Inspirato/SwiftPhotoGallery.git", :tag => "#{s.version}" }
  s.swift_version    = '5.0'

  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "10.0"

  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit', 'Foundation'
end
