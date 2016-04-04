#
# Be sure to run `pod lib lint PTBalloonView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PTBalloonView"
  s.version          = "0.1.0"
  s.summary          = "The view and label, like balloon."
  s.description      = <<-DESC
  PTBalloonView and PTBalloonLabel are the view and label, like balloon.
  It is easy to use this balloon view and label.
  There are balloon inflating and deflating animations to attention.
                       DESC
  s.homepage         = "https://github.com/pjocprac/PTBalloonView"
  s.license          = 'MIT'
  s.author           = { "Takeshi Watanabe" => "watanabe@tritrue.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/PTBalloonView.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
end
