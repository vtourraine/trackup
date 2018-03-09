#
#  Be sure to run `pod spec lint TrackupCore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name = "TrackupCore"
  s.version = "0.0.1"
  s.summary = "Markdown-based changelog/roadmap tracking."

  s.description  = <<-DESC
    Markdown-based changelog/roadmap tracking.
                   DESC

  s.homepage = "https://github.com/vtourraine/trackup"
  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "Vincent Tourraine" => "me@vtourraine.net" }
  s.social_media_url = "http://twitter.com/vtourraine"

  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source = { :git => "https://github.com/vtourraine/trackup.git", :tag => "#{s.version}" }

  s.source_files = "trackup-core/*.swift"

end
