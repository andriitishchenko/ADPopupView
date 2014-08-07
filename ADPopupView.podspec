Pod::Spec.new do |s|


  s.name         = "ADPopupView"
  s.version      = "1.0.0"
  s.summary      = "ADPopupView is an iOS drop-in classes that displays popup at custom point in custom view."

  s.description  = <<-DESC
                   ADPopupView works on any iOS version only greater or equal than 4.3 and is compatible with only ARC projects.
                  Frameworks:
                  * Foundation.framework
                  * UIKit.framework
                  * CoreGraphics.framework
                  
                  You will need LLVM 3.0 or later in order to build ADPopupView.
                   DESC

  s.homepage     = "https://github.com/Antondomashnev/ADPopupView"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Anton Domashnev" => "andrii.tishchenko+github@gmail.com" }

  s.platform     = :ios
  s.platform     = :ios, "6.0"

  s.source       = { :git => "git@github.com:andriitishchenko/ADPopupView.git", :tag => "v#{s.version.to_s}" }

  s.source_files  = "Source/*.{h,m}"
  s.exclude_files = "Demo/*.*"
  s.requires_arc = true

end