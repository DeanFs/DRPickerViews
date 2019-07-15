#
# Be sure to run `pod lib lint DRPickerViews.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DRPickerViews'
  s.version          = '0.1.0'
  s.summary          = '自定义选择器集合'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/DeanFs/DRPickerViews'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dean_F' => 'stone.feng1990@gmail.com' }
  s.source           = { :git => 'https://github.com/DeanFs/DRPickerViews.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  # 图片，xib等资源文件
  s.resource = 'DRPickerViews/Assets/*', 'DRPickerViews/Classes/**/*.xib'

  s.subspec 'DatePickers' do |ss|
    ss.source_files = 'DRPickerViews/Classes/DatePickers/*.{h,m}'

    ss.subspec 'SubViews' do |sss|
      sss.source_files = 'DRPickerViews/Classes/DatePickers/SubViews/*.{h,m}'
    end

    ss.subspec 'Classes' do |sss|
      sss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/*.{h,m}'

      sss.subspec 'DRYMDWithLunarPicker' do |ssss|
        ssss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/DRYMDWithLunarPicker/*.{h,m}'
        ssss.subspec 'DataSource' do |sssss|
          sssss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/DRYMDWithLunarPicker/DataSource/*.{h,m}'
        end
      end

      sss.subspec 'DRTimeConsumingPicker' do |ssss|
        ssss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/DRTimeConsumingPicker/*.{h,m}'
      end

      sss.subspec 'DRYMDPicker' do |ssss|
        ssss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/DRYMDPicker/*.{h,m}'
      end

      sss.subspec 'DRYMDWithTodayPicker' do |ssss|
        ssss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/DRYMDWithTodayPicker/*.{h,m}'
      end

      sss.subspec 'DRYearMonthPicker' do |ssss|
        ssss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/DRYearMonthPicker/*.{h,m}'
      end

      sss.subspec 'DRMDWTPicker' do |ssss|
         ssss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/DRMDWTPicker/*.{h,m}'
      end

      sss.subspec 'DRHourMinutePicker' do |ssss|
        ssss.source_files = 'DRPickerViews/Classes/DatePickers/Classes/DRHourMinutePicker/*.{h,m}'
      end
    end
  end
  
  # s.resource_bundles = {
  #   'DRPickerViews' => ['DRPickerViews/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
