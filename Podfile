# Uncomment the next line to define a global platform for your project
# platform :ios, `15.0`

target 'Basecamp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Basecamp
  pod 'KakaoSDK'
  pod 'Moya/RxSwift'
  pod 'RealmSwift'
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Tabman'
  pod 'RxGesture'
  pod 'RxEnumKit'
  pod 'RxDataSources'
  pod 'SnapKit'
  pod 'Toast-Swift'
  pod 'DropDown'
  pod 'FMPhotoPicker'
  pod 'FSPagerView'
  pod 'TTGTagCollectionView'
  pod 'HorizonCalendar'
  pod 'GoogleMaps'
  pod 'Google-Maps-iOS-Utils'
  pod 'Cosmos'

  target 'BasecampTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '6.5.0'
    pod 'RxTest', '6.5.0'
  end

  target 'BasecampUITests' do
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
  end
end