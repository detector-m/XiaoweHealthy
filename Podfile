# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

use_modular_headers!
inhibit_all_warnings!
pre_install do |installer|
    remove_swiftui()
end

def remove_swiftui
  # 解决 xcode13 Release模式下SwiftUI报错问题
  system("rm -rf ./Pods/Kingfisher/Sources/SwiftUI")
  code_file = "./Pods/Kingfisher/Sources/General/KFOptionsSetter.swift"
  code_text = File.read(code_file)
  code_text.gsub!(/#if canImport\(SwiftUI\) \&\& canImport\(Combine\)(.|\n)+#endif/,'')
  system("rm -rf " + code_file)
  aFile = File.new(code_file, 'w+')
  aFile.syswrite(code_text)
  aFile.close()
end

target 'XiaoweHealthy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for XiaoweHealthy

  # 日志
  pod 'XCGLogger'
  
  # 内存监测 FBRetainCycleDetector
#  pod 'FBRetainCycleDetector'
  
  # 网络监测
  pod 'ReachabilitySwift'
  
  # 卡顿监测
  # pod 'CatonMonitor'
  
  # 调用栈
#  pod 'RCBacktrace'
  
  # 类的方法拓展
  pod 'SwifterSwift'
  
  # 数据库
  pod 'GRDB.swift'
  
  # 加密算法
  pod 'CryptoSwift'
  
  # 网络请求
  pod 'Moya'
  
  # 模型转换
  pod 'SwiftyJSON'
#  pod 'ObjectMapper'
  pod 'HandyJSON'
  
  # HealthKitReporter
  pod 'HealthKitReporter'
  
  # 缓存
  pod 'Cache'
  
  # GPS 定位
#  pod 'SwiftLocation/Core'
  
  # 图表
#  pod 'Charts'
#  pod 'AAInfographics'
  
  # 异步编程
#  pod 'RxSwift'

  # 日期转换
  pod 'SwiftDate'
  
  # 代码布局
  pod 'SnapKit'
  
  # 富文本标签
  pod 'ActiveLabel'
  
  # RichString
  pod 'SwiftRichString'
  
  # 弹出菜单
  pod 'FTPopOverMenu_Swift'
  
  # 弹出tip
  pod 'AMPopTip'
  
  # 键盘管理
  pod 'IQKeyboardManagerSwift'
  
  # UI 方面
  pod "ESTabBarController-swift"
  pod "RTRootNavigationController"
  
  # 空页面
  pod 'EmptyDataSet-Swift'
  
  # 轮播图
  pod 'FSPagerView'
  
  # 分页控制器
  pod 'Tabman'
  
  # 分段控件
  pod 'BetterSegmentedControl'
  
  # 下载进度条
  pod 'LinearProgressBar'
  
  # 圆形进度
  pod 'KDCircularProgress'
  
  # 三环
#  pod 'MKRingProgressView'
  
  # 文件下载管理
  pod 'Tiercel'
  
  # 网络图片处理
  pod 'Kingfisher'
  
  # 联系人
  pod 'SwiftyContacts'
  
  # 日历
  pod 'JTAppleCalendar'
#  pod 'FSCalendar'
  
  # 文件管理
#  pod 'Files'
#  pod "FilesProvider"
  
  # toast
  pod 'Toast-Swift'
  
  # 资源处理
  pod 'R.swift'
  
  # 字体管理
  pod 'UIFontComplete'
  # 查看项目中自定义字体
#  pod 'FontBlaster'

  # 下拉刷新
  pod 'MJRefresh'
  
  # 引导页
  pod 'SwiftyOnboard'
  
  # 隐私权限 (PermissionsKit)
#  pod 'PermissionsKit/BluetoothPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'

  
  # 三端易用的现代跨平台 Javascript bridge， 通过它，你可以在Javascript和原生之间同步或异步的调用彼此的函数.
#  pod "dsBridge"
  
  # 优创亿的SDK 依赖
  pod 'iOSOTARTK'
  pod 'iOSDFULibrary'
  
  
  # 友盟集成
  # 友盟统计
  # 必须集成
  pod 'UMCommon'
  pod 'UMDevice'
  
  # 性能检监测 错误分析升级为独立SDK，看crash数据请务必集成
  pod 'UMAPM'
  
  # 推送
  pod 'UMPush'
  
  # 社会化分享
  pod 'UMShare/Social/WeChat'
  pod 'UMShare/Social/QQ'

#  pod 'UMShare/Social/ReducedWeChat'
#  pod 'UMShare/Social/ReducedQQ'

  
  # 集成新浪微博(精简版1M)
#  pod 'UMShare/Social/ReducedSina'

  target 'XiaoweHealthyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'XiaoweHealthyUITests' do
    # Pods for testing
  end

end
