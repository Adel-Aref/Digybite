# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'DigybiteTask' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DigybiteTask
	pod 'Alamofire'
	pod 'RealmSwift', '~>10'
	pod 'SDWebImage'

  target 'DigybiteTaskTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DigybiteTaskUITests' do
    # Pods for testing
  end

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
        File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      end
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
  installer.generated_projects.each do |project|
        project.targets.each do |target|
             target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
             end
        end
  end
end
