# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'

target 'Spotagory' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Spotagory
  
  pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.5.0'
#  pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON', :branch => 'swift2'

#  pod 'AFNetworking'
  pod 'iCarousel'
  pod 'TPKeyboardAvoiding'
  pod 'SDWebImage'
  pod 'DGActivityIndicatorView'
  pod 'MBProgressHUD'
  pod 'Kingfisher', '~> 2.1'
  use_frameworks!
  pod 'MXSegmentedPager'
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "2.3"
        end
    end
end

