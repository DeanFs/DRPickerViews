#
# Be sure to run `pod lib lint DRPickerViews.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DRPickerViews'
  s.version          = '0.3.7'
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

  s.subspec 'Pickers' do |ss|
    ss.subspec 'Common' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/Common/*.{h,m}'
    end

    ss.subspec 'AheadTimePicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/AheadTimePicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'ValueSelectPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/ValueSelectPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'TimeConsumingPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/TimeConsumingPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'StringOptionPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/StringOptionPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'HourMinutePicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/HourMinutePicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'YearMonthPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/YearMonthPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'YearMonthDayPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/YearMonthDayPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'YearOrYearMonthPicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/YearOrYearMonthPicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'WithLunarPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/WithLunarPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'OneWeekPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/OneWeekPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'OptionCardPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/OptionCardPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'CityPicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/CityPicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'ClassTableWeekPicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/ClassTableWeekPicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'ClassDurationPicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/ClassDurationPicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'ClassTimeRemindPicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/ClassTimeRemindPicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end

    ss.subspec 'ClassTermPicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/ClassTermPicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end
    
    ss.subspec 'LinkagePicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/LinkagePicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end
    
    ss.subspec 'MultipleColumnPicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/MultipleColumnPicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end
    
    ss.subspec 'DateToNowPicker' do |sss|
        sss.source_files = 'DRPickerViews/Classes/Pickers/DateToNowPicker/*.{h,m}'
        sss.dependency 'DRPickerViews/Pickers/Common'
    end
  end

  s.subspec 'Factory' do |ss|
    ss.source_files = 'DRPickerViews/Classes/Factory/*.{h,m}'
    ss.dependency 'DRPickerViews/Pickers'
  end
  
  # s.resource_bundles = {
  #   'DRPickerViews' => ['DRPickerViews/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'DRCategories'
  s.dependency 'DRMacroDefines'
  s.dependency 'HexColors', '4.0.0'
  s.dependency 'DRUIWidgetKit'

end
