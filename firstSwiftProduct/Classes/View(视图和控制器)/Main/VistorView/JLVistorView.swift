//
//  JLVistorView.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/29.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit

//访客视图
class JLVistorView: UIView {
    
    
    // MARK：- 设置访客视图信息
    /// 使用字典设置访客视图的信息
    ///
    /// - parameter dict: [imageName / Message]
    /// 提示:如果是首页 imageName == ""
    var vistorInfo:[String:String]?{
        didSet{
            //1> 去字典信息
            guard let imageName = vistorInfo?["imageName"],
                let message = vistorInfo?["message"] else{
                    return;
            }
            //2> 设置消息
            tipLabel.text = message;
            //3> 设置图像，首页不需要设置
            if imageName == "" {
                
                startAnimation();
                
                return;
            }
            
            iconView.image = UIImage.init(named: imageName);
            
            //其他控制器的访客视图不需要显示小房子和遮罩视图
            houseIconView.isHidden = true;
            maskIcon.isHidden = true;
        }
    };
    
    // MARK: 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }

    // 旋转图标动画（首页）
    private func startAnimation(){
        
        let anim = CABasicAnimation.init(keyPath: "transform.rotation");
        
        anim.toValue = 2 * M_PI;
        anim.repeatCount = MAXFLOAT;
        anim.duration = 15;
        
        // 动画完成不删除，如果 iconView 被释放，动画会一起销毁
        // 在设置连续播放的动画非常有用！
        anim.isRemovedOnCompletion = false;
        
        //将动画添加到图层
        iconView.layer.add(anim, forKey: nil);
        
    }
    
    // MARk: - 私有控件
    /// 懒加载属性只有调用 UIKit 控件的指定构造函数，其他都需要使用类型
    /// 图像视图
    fileprivate lazy var iconView = UIImageView(image:UIImage(named:"visitordiscover_feed_image_smallicon"));
    /// 遮罩图像
    fileprivate lazy var maskIcon:UIImageView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_mask_smallicon"))
    /// 小房子
    fileprivate lazy var houseIconView = UIImageView(image:UIImage(named:"visitordiscover_feed_image_house"));
    /// 提示标签
    fileprivate lazy var tipLabel:UILabel = UILabel.cz_label(
        withText: "关注一些人，回这里看看有什么惊喜 关注一些人，回这里看看有什么惊喜",
        fontSize: 14,
        color: UIColor.darkGray);
    /// 注册按钮
    lazy var registerBtn:UIButton = UIButton.cz_textButton(
        "注册",
        fontSize: 16,
        normalColor: UIColor.orange,
        highlightedColor: UIColor.black,
        backgroundImageName:"common_button_white_disable");
    /// 登录按钮
    lazy var loginBtn:UIButton = UIButton.cz_textButton(
        "登录",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightedColor: UIColor.black,
        backgroundImageName:"common_button_white_disable");
}

// MARK: — 设置界面
extension JLVistorView{
    
   fileprivate func setupUI(){
    
        backgroundColor = UIColor.cz_color(withHex: 0xEDEDED);
    
        //1. 添加控件
        addSubview(iconView);
        addSubview(maskIcon);
        addSubview(houseIconView);
        addSubview(tipLabel);
        addSubview(registerBtn);
        addSubview(loginBtn);
    
        // 文本居中
        tipLabel.textAlignment = .center;
    
        //2. 取消 autoresizing
        for v in subviews{
            v.translatesAutoresizingMaskIntoConstraints = false;
        }
    
        //3. 自动布局
        // - 图像视图
        addConstraint(NSLayoutConstraint.init(item: iconView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0));
        addConstraint(NSLayoutConstraint.init(item: iconView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1.0,
                                              constant: -60));
        // - 小房子
        addConstraint(NSLayoutConstraint.init(item: houseIconView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: iconView,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0));
        addConstraint(NSLayoutConstraint.init(item: houseIconView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: iconView,
                                              attribute: .centerY,
                                              multiplier: 1.0,
                                              constant: 0));
        //提示标签
        addConstraint(NSLayoutConstraint.init(item: tipLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: iconView,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0));
        addConstraint(NSLayoutConstraint.init(item: tipLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: iconView,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 20));
        addConstraint(NSLayoutConstraint.init(item: tipLabel,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 236));
        //注册按钮
        addConstraint(NSLayoutConstraint.init(item: registerBtn,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: tipLabel,
                                              attribute: .left,
                                              multiplier: 1.0,
                                              constant: 0));
        addConstraint(NSLayoutConstraint.init(item: registerBtn,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: tipLabel,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 20));
        addConstraint(NSLayoutConstraint.init(item: registerBtn,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: 100));
        //登录按钮
        addConstraint(NSLayoutConstraint.init(item: loginBtn,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: tipLabel,
                                              attribute: .right,
                                              multiplier: 1.0,
                                              constant: 0));
        addConstraint(NSLayoutConstraint.init(item: loginBtn,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: tipLabel,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 20));
        addConstraint(NSLayoutConstraint.init(item: loginBtn,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: registerBtn,
                                              attribute: .width,
                                              multiplier: 1.0,
                                              constant: 0));
        //遮罩图像  VFL布局
        //view: 定义 VFL 中的控件名称和实际名称映射关系
        //metrics: 定义 VFL 中 () 指定的常数映射关系
        addConstraints(NSLayoutConstraint.constraints(
                                              withVisualFormat: "H:|-0-[maskIcon]-0-|",
                                              options: [],
                                              metrics: nil,
                                              views: ["maskIcon":maskIcon,
                                                      "registerBtn":registerBtn]));
        //V:|-0-[maskIcon]-(\(-registerBtn.bounds.size.height))-[registerBtn]",
        addConstraints(NSLayoutConstraint.constraints(
                                              withVisualFormat: "V:|-0-[maskIcon]-(\(20))-[registerBtn]",
                                              options: [],
                                              metrics: nil,
                                              views: ["maskIcon":maskIcon,
                                                        "registerBtn":registerBtn]));
    }
    
}


