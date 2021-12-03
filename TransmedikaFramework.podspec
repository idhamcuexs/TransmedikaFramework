#
#  Be sure to run `pod spec lint TransmedikaFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |spec|


  spec.name         = "TransmedikFramework"
  spec.version      = "1.0.0"
  spec.summary      = "TransmedikFramework"
  spec.description  = "this framework for We Plus apps"
  
  spec.homepage     = "https://github.com/idhamcuexs/TransmedikaFramework"
  spec.license      = "MIT"
  spec.authors            = { "Idham kurniawan" => "idham290593@gmail.com" }

  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/idhamcuexs/TransmedikaFramework.git", :tag => spec.version.to_s }

  spec.source_files  = "TransmedikFramework/**/*.{swift}"
  spec.swift_version = "4.0"

end


