//
//  JLNavigationController.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/24.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit

class JLNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //隐藏默认的 NavigationBar
        navigationBar.isHidden = true;
    }

    /// 重写 push 方法，所有的 push 动作都会调用这个方法
    /// viewController 是被 push 的控制器，设置他的左侧按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 如果不是栈底控制器才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0 {
            //隐藏底部的 tabbar
            viewController.hidesBottomBarWhenPushed = true;
            
            //判断控制器的类型
            if let vc = viewController as? JLBaseViewController {
                
                var title = "返回";
                
                // 判断控制器的级数，只有一个子控制器的时候，显示栈底控制器的标题
                if childViewControllers.count == 1 {
                    // title 显示首页的标题
                    title = childViewControllers.first?.title ?? "返回";
                }
                
                // 去除自定义的 navItem
                vc.navItem.leftBarButtonItem = UIBarButtonItem.init(leftTitle: title, fontSize: 16, target: self, action: #selector(popToParent), isBackBtn: true);
            }
        }
        
        
        super.pushViewController(viewController, animated: animated);
    }
    
    @objc private func popToParent(){
        
        popViewController(animated: true);
        
    }
}
