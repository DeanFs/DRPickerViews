#
# Be sure to run `pod lib lint DRPickerViews.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DRPickerViews'
  s.version          = '0.1.9'
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

  s.subspec 'UIWidget' do |ss|
    ss.subspec 'Common' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/Common/*.{h,m}'
    end

    ss.subspec 'TopBar' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/TopBar/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end

    ss.subspec 'Segment' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/Segment/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end

    ss.subspec 'SectionView' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/SectionView/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end

    ss.subspec 'OptionCard' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/OptionCard/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end

    ss.subspec 'CalendarTitleView' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/CalendarTitleView/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
      sss.dependency 'DRPickerViews/Pickers/YearMonthPicker'
    end

    ss.subspec 'HourMinutePickerView' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/HourMinutePickerView/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end

    ss.subspec 'DatePickerView' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/DatePickerView/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end

    ss.subspec 'LunarDatePickerView' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/LunarDatePickerView/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end

    ss.subspec 'WeekPickerView' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/WeekPickerView/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end

    ss.subspec 'PickerContainerView' do |sss|
      sss.source_files = 'DRPickerViews/Classes/UIWidget/PickerContainerView/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/Common'
    end
  end

  s.subspec 'Pickers' do |ss|
    ss.subspec 'Common' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/Common/*.{h,m}'
      sss.dependency 'DRPickerViews/UIWidget/PickerContainerView'
      sss.dependency 'DRPickerViews/UIWidget/TopBar'
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
      sss.dependency 'DRPickerViews/UIWidget/OptionCard'
      sss.dependency 'DRPickerViews/UIWidget/HourMinutePickerView'
    end

    ss.subspec 'YearMonthPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/YearMonthPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
      sss.dependency 'DRPickerViews/UIWidget/SectionView'
      sss.dependency 'DRPickerViews/UIWidget/OptionCard'
      sss.dependency 'DRPickerViews/UIWidget/DatePickerView'
    end

    ss.subspec 'YearMonthDayPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/YearMonthDayPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
      sss.dependency 'DRPickerViews/UIWidget/SectionView'
      sss.dependency 'DRPickerViews/UIWidget/DatePickerView'
      sss.dependency 'DRPickerViews/UIWidget/OptionCard'
    end

    ss.subspec 'WithLunarPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/WithLunarPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
      sss.dependency 'DRPickerViews/UIWidget/Segment'
      sss.dependency 'DRPickerViews/UIWidget/DatePickerView'
      sss.dependency 'DRPickerViews/UIWidget/LunarDatePickerView'
    end

    ss.subspec 'OneWeekPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/OneWeekPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
      sss.dependency 'DRPickerViews/UIWidget/WeekPickerView'
    end

    ss.subspec 'OptionCardPicker' do |sss|
      sss.source_files = 'DRPickerViews/Classes/Pickers/OptionCardPicker/*.{h,m}'
      sss.dependency 'DRPickerViews/Pickers/Common'
      sss.dependency 'DRPickerViews/UIWidget/SectionView'
      sss.dependency 'DRPickerViews/UIWidget/OptionCard'
    end
  end

  s.subspec 'Factory' do |ss|
    ss.source_files = 'DRPickerViews/Classes/Factory/*.{h,m}'
    ss.dependency 'DRPickerViews/Pickers'
    ss.dependency 'DRPickerViews/UIWidget'
  end
  
  # s.resource_bundles = {
  #   'DRPickerViews' => ['DRPickerViews/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'DRCategories'
  s.dependency 'DRMacroDefines'
  s.dependency 'Masonry'
  s.dependency 'BlocksKit'
  s.dependency 'HexColors', '4.0.0'
  s.dependency 'DRToastView'

end
