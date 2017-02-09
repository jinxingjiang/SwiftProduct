//
//  UIBarButtonItem+Extensions.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/25.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit


extension UIBarButtonItem{
    
    /// 便利构造函数
    /// 创建 UIBarButtonItem
    convenience init(leftTitle:String,fontSize:CGFloat = 16,target:AnyObject?,action: Selector,isBackBtn:Bool = false) {
        
        let btn:UIButton = UIButton.cz_textButton(leftTitle, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange);
        
        // 判断设置返回按钮的图片
        if isBackBtn {
            let imageName = "navigationbar_back_withtext";
            btn.setImage(UIImage(named:imageName), for: UIControlState(rawValue: 0));
            btn.setImage(UIImage(named:imageName+"_highlighted"), for: .highlighted);
            btn.sizeToFit();
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside);
        
        // self.init 实例化 UIBarButtonItem
        self.init(customView:btn);
    }
    
}
