#
# Be sure to run `pod lib lint DRPickerViews.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DRPickerViews'
  s.version          = '0.4.4'
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
  
  s.subspec 'UIWidget' do |ss|
      ss.subspec 'Common' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/Common/*.{h,m}'
      end
      
      ss.subspec 'PickerContainerView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/PickerContainerView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
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
      
      ss.subspec 'ValuePickerView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/ValuePickerView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
      end
      
      ss.subspec 'CityPickerView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/CityPickerView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
      end
      
      ss.subspec 'NormalDataPickerView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/NormalDataPickerView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
      end
      
      ss.subspec 'ClassDurationPickerView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/ClassDurationPickerView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/NormalDataPickerView'
      end
      
      ss.subspec 'ClassRemindTimePickerView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/ClassRemindTimePickerView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/NormalDataPickerView'
      end
      
      ss.subspec 'ClassTermPickerView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/ClassTermPickerView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/NormalDataPickerView'
      end
      
      ss.subspec 'CheckboxGroupView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/CheckboxGroupView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/NormalDataPickerView'
      end
      
      # 布局信息
      ss.subspec 'CustomLayout' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/CustomLayout/*/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
      end
      
      # 星星评级
      ss.subspec 'StarRateView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/StarRateView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
      end
      
      # pageControl
      ss.subspec 'DRPageControl' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/DRPageControl/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
      end
      
      # 音频录音水波
      ss.subspec 'VoiceWaveView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/VoiceWaveView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
      end
      
      # 控件水平collectionview 带pagecontrol
      ss.subspec 'HorizenPageView' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/HorizenPageView/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/Common'
          sss.dependency 'DRPickerViews/UIWidget/CustomLayout'
          sss.dependency 'DRPickerViews/UIWidget/DRPageControl'
      end
      
      ss.subspec 'DRTableViews' do |sss|
          sss.subspec 'DRDragSortTableView' do |ssss|
              ssss.source_files = 'DRPickerViews/Classes/UIWidget/DRTableViews/DRDragSortTableView/*.{h,m}'
              ssss.dependency 'DRPickerViews/UIWidget/Common'
          end
          
          sss.subspec 'DRTextScrollView' do |ssss|
              ssss.source_files = 'DRPickerViews/Classes/UIWidget/DRTableViews/DRTextScrollView/*.{h,m}'
          end
      end
      
      
      ss.subspec 'DRCollectionViews' do |sss|
          sss.subspec 'FoldableView' do |ssss|
              ssss.source_files = 'DRPickerViews/Classes/UIWidget/DRCollectionViews/FoldableView/*.{h,m}'
          end
          
          sss.subspec 'TimeFlowView' do |ssss|
              ssss.source_files = 'DRPickerViews/Classes/UIWidget/DRCollectionViews/TimeFlowView/*.{h,m}'
              ssss.dependency 'DRPickerViews/UIWidget/Common'
          end
      end
      
      # 卡片页面控制器，弹窗页面容器
      ss.subspec 'CardContainer' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/CardContainer/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/DRTableViews/DRDragSortTableView'
      end
      
      ss.subspec 'ActionSheet' do |sss|
          sss.source_files = 'DRPickerViews/Classes/UIWidget/ActionSheet/*.{h,m}'
          sss.dependency 'DRPickerViews/UIWidget/CardContainer'
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
  s.dependency 'Masonry'
  s.dependency 'DRToastView'
  s.dependency 'BlocksKit'
  s.dependency 'YYModel'
  s.dependency 'SDWebImage'
  s.dependency 'RTRootNavigationController'
  s.dependency 'Aspects'

end
