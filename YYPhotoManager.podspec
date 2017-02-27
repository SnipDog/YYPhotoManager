Pod::Spec.new do |s|
s.name             = "YYPhotoManager"
s.version          = "1.0"
s.summary          = "Simple manager to take photo or select photo from album."
s.homepage         = "https://github.com/Heisenbean/YYPhotoManager"
s.license          = "MIT"
s.author           = { "Heisenbean" => "heisenbean.me@gmail.com" }
s.source           = { :git => "https://github.com/Heisenbean/YYPhotoManager.git", :tag => "1.0" }
s.social_media_url = "https://twitter.com/hedongbin"
s.source_files     = "YYPhotoManager/*.{h,m}"
s.exclude_files    = "YYPhotoManager/*.{h,m}"
s.resource_bundles = { "YYPhotoManager" => "YYPhotoManager/*.{lproj,storyboard,xib,nib}" }
s.platform         = :ios, "8.0"
s.requires_arc     = true
# s.frameworks       = "Photos"
end
