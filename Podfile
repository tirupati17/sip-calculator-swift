platform :ios, :deployment_target => "7.0"

def pods
    pod 'Flurry-iOS-SDK/FlurrySDK'
    pod 'Appirater', '~> 2.0.4'
    pod 'Google-Mobile-Ads-SDK', '~> 7.5'
    pod 'Firebase/Core'
    pod 'Fabric'
    pod 'Crashlytics'
end

target 'SIP' do
    pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
