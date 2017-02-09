//
//  JLMainViewController.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/24.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit

class JLMainViewController: UITabBarController {

    // 定时器
    fileprivate var timer: Timer?
    
    ///撰写按钮
    fileprivate lazy var composeButton:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBarItem();
        setupComposeButoon();
        setUpTimer();
        
    }

    deinit {
        //销毁时钟
        timer?.invalidate();
    }
    /**
     portrait    : 竖屏，肖像
     landscape   : 横屏，风景画
     
     - 使用代码控制设备的方向，好处，可以在在需要横屏的时候，单独处理！
     - 设置支持的方向之后，当前的控制器及子控制器都会遵守这个方向！
     - 如果播放视频，通常是通过 modal 展现的！
     */
//    class func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return .portrait
//    }
    
    //@objc 允许这个函数在”运行时“通过oc的消息机制被调用
    @objc fileprivate func composeButtonClicked(){
        print("撰写微博")
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension JLMainViewController{
    
    /// 定义时钟
    fileprivate func setUpTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true);
        
    }
    
    /// 时钟触发方法
    @objc private func updateTimer(){
        
        JLNetWorkTools.shared.unreadCount { (count) in
            
            // 设置 首页 tabbar 的 badgeNumber
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)":nil;
            
            // 设置 App 的 badgeNumber, 从 iOS 8.0 之后 血药用户授权才能使用
            UIApplication.shared.applicationIconBadgeNumber = count;
        }
    }
    
}
//extension 类似于 OC 中的分类，在 Swift 中还可以用来切分代码块
//可以把相近功能的函数，放在一个 extension 中
//便于代码维护
//注意：和 OC 的分类一样，extension 中不能定义属性
// MARK: - 设置界面
extension JLMainViewController{
    
    //设置撰写按钮
    fileprivate func setupComposeButoon(){
        
        tabBar.addSubview(composeButton);
        
        //设置按钮的位置
        // - 计算按钮的宽度
        // - w-1 操作是为了处理tabbar容错点的问题
        let count = CGFloat(childViewControllers.count);
        let w = tabBar.bounds.width / count - 1;
        
        //CGRectInset
        // - dx：正数向内缩进，负数向外扩展
        // - dy: 选择btn的y轴坐标
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0);
        
        //为按钮绑定方法
        composeButton.addTarget(self, action:#selector(composeButtonClicked), for: .touchUpInside);
    }
    
    fileprivate func setUpTabBarItem(){
        
//        let array = [
//            ["className":"JLHomeViewController","title":"首页","imageName":"home","vistorInfo":
//                ["imageName":"","message":"关注一些人，回这里看看有什么惊喜"]],
//            
//            ["className":"JLMessageViewController","title":"信息","imageName":"message_center","vistorInfo":
//                ["imageName":"visitordiscover_image_message","message":"登录后，别人评论你的微博，发给你的消息，都会在这里收到通知"]],
//            
//            ["className":"UIViewController"],
//            
//            ["className":"JLDiscoverViewController","title":"发现","imageName":"discover","vistorInfo":
//                ["imageName":"visitordiscover_image_message","message":"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过"]],
//            
//            ["className":"JLProfileViewController","title":"我","imageName":"profile","vistorInfo":
//                ["imageName":"visitordiscover_image_profile","message":"登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]]
//        ];
        
        //测试数据
        //(array as NSArray).write(toFile: "\(NSHomeDirectory()/Documents/appImage.plist)", atomically: true);
        //把json数据序列化写入本地
//        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted]);
//        (data as NSData).write(toFile: "/Users/yuehai/Desktop/demo.json", atomically: true);
        
        
        //从 bundle 中加载mainTabbar配置的json数据
        // 0> 从沙盒获取 json 路径 / 1> 获取本地的Json配置数据 / 2> 根据路径加载 NSDta / 3> 反序列化转换成数组
        let docDic = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let jsonPath = (docDic as NSString).appendingPathComponent("main.json") as String;
        var data = NSData.init(contentsOfFile: jsonPath);
        
        if data == nil{
            
            let path = Bundle.main.path(forResource: "main.json", ofType: nil);
            
            data = NSData.init(contentsOfFile: path!);

        }
        
        guard let array = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [[String : AnyObject]]
            else {
                return
        }
        
        //设置数组初始化接收tabbar子视图控制器
        //遍历 视图数组 添加到 tabbar
        var arrayM = [UIViewController]();
        for dict in array! {
            arrayM.append(controller(dict: dict as [String : AnyObject]));
        }
        
        // 设置 tabbar 的子控制器
        viewControllers = arrayM;
        
        self.tabBar.tintColor = UIColor.orange;
        
    }
    
    /// 使用字典传建一个子视图控制器
    ///
    /// - prameter dict：信息字典[clasddName，title，imageName,"vistorInfo"]
    ///
    /// - return：子视图控制器
    private func controller(dict:[String:AnyObject]) -> UIViewController{
        
        // let clssName = "\(Bundle.main.infoDictionary!["CFBundleName"] as! String).\(className)";
        guard let className = dict["className"] as? String,
                  let title = dict["title"] as? String,
              let imageName = dict["imageName"] as? String,
             let childClass = NSClassFromString(Bundle.main.namespace+"."+className) as? JLBaseViewController.Type,
              let vistorDic = dict["vistorInfo"] as? [String:String]
            else {
                return UIViewController()
        }

        //2. 创建视图控制器
        //1> 通过 反射机制 获取到类名
        
        let vc = childClass.init();
        vc.title = title;
        
        //设置控制器的访客信息字典
        vc.vistorInfoDic = vistorDic;
        
        //3. 设置图像 
        // - 常态下 tabbarItem 的图片
        vc.tabBarItem.image = UIImage(named:"tabbar_"+imageName);
        // - 选中状态下 tabbarItem 的图片
        vc.tabBarItem.selectedImage = UIImage(named:"tabbar_" + imageName + "_selected");
        
        //4. 设置 tabbar 的标题字体
        // - 设置被选中状态下的 标题 颜色
        vc.tabBarItem.setTitleTextAttributes(
            [NSForegroundColorAttributeName:UIColor.orange], for: .highlighted);
        // - 系统默认的字体大小为12号大小，要设置 Normal 的字体大小
        vc.tabBarItem.setTitleTextAttributes(
            [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: UIControlState(rawValue: 0));
        
        //实例化导航控制器的时候，会调用 push 方法将 rootVC 压栈
        let nav = JLNavigationController(rootViewController: vc);
        
        return nav;
        
    }
    
}





