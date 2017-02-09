//
//  JLDemoViewController.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/25.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit

class JLDemoViewController: JLBaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.backgroundColor = UIColor.brown;
        
        setUpTableView();
        
         navItem.title = "第\(navigationController?.childViewControllers.count ?? 0)个";
    }
    
    @objc fileprivate func showNext(){
        
        let vc = JLDemoViewController();
        
        navigationController?.pushViewController(vc, animated: true);
        
    }

}

extension JLDemoViewController{
    
    override func setUpTableView(){
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"下一个", style:.plain, target:self, action: #selector(showNext));
        
        //在父类的方法基础上 扩展父类的方法
        super.setUpTableView();
        
        navItem.rightBarButtonItem = UIBarButtonItem.init(leftTitle: "下一个", target: self, action: #selector(showNext));
        
    }
    
}



