//
//  AppDelegate.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/23.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
// - 用来定义设备方向的属性
    var blockRotation: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("\(NSHomeDirectory())")
        
        // #available 是检测设备版本， 如果是 10.0 以上
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.carPlay,.sound], completionHandler: { (success, error) in
                print("授权" + (success ? "成功":"失败"))
            })
        } else {
            // 10.0 以下
            // Fallback on earlier versions
            // 取得用户授权显示通知 [上方的提示条/声音/badgeNumber]
            application.registerUserNotificationSettings(UIUserNotificationSettings.init(types: [.alert,.badge,.sound], categories: nil));
        }
        
        //设置根视图控制器
        window = UIWindow();
        window?.backgroundColor = UIColor.white;
        
        //通过"反射机制"设置试图控制器
        // - 通过NSBundle 获取到info.plist文件中 ”命名空间“ 字段
        // - Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""  将获取到的命名空间字段通过as转化成String类型，因为其为可选型，所以加为空时的操作
        let className = "\(Bundle.main.namespace).JLMainViewController";
        // - 通过 NSClassFromString 获取到相对应的视图控制器
        let cls = NSClassFromString(className) as? UIViewController.Type;
        // - 初始化获取到的视图控制器
        let vc = cls?.init();
        
        window?.rootViewController = vc;
        
        //传统设置根视图控制器
        //window?.rootViewController = JLMainViewController();
 
        window?.makeKeyAndVisible();
        
        loadAppInfo();
        
        return true
    }
    
    /**
     portrait    : 竖屏，肖像
     landscape   : 横屏，风景画
     
     - 使用代码控制设备的方向，好处，可以在在需要横屏的时候，单独处理！
     - 设置支持的方向之后，当前的控制器及子控制器都会遵守这个方向！
     - 如果播放视频，通常是通过 modal 展现的！
     */
    func application(_ supportedInterfaceOrientationsForapplication: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.blockRotation{
            return UIInterfaceOrientationMask.all
        } else {
            return UIInterfaceOrientationMask.portrait
        }
        
        
    }

}
// MARK: - 模拟网络加载应用程序配置 json
extension AppDelegate{
    
    fileprivate func loadAppInfo(){
        
        //1. 模拟异步
        DispatchQueue.global().async {
            
            // 1> url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil);
            
            // 2 > data
            let data = NSData.init(contentsOf: url!);
            
            // 3 > 写入磁盘
            let docDic = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let jsonPath = (docDic as NSString).appendingPathComponent("main.json");
            
            // 4> 直接保存在沙盒中，等待程序下一次启动使用，实现界面UI图片的实时变化功能
            data?.write(toFile: jsonPath, atomically: true);
            
        }
        
    }
    
}



