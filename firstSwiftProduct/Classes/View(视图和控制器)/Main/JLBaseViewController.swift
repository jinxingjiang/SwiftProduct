//
//  JLBaseViewController.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/24.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit

class JLBaseViewController: UIViewController{
    
    
    /// 判断用户是否登录
    var userLogon = true;
    /// 访客视图信息字典
    var vistorInfoDic:[String:String]?;
    
    
    /// -表格试图 如果用户没有登录，就不创建
    var tableView: UITableView?
    /// -刷新控件
    var refreshControl: UIRefreshControl?
    /// 上拉刷新的标记
    var isPuall = false;

    
    //自定义导航条
    lazy var navigationBar = UINavigationBar(frame:CGRect(x: 0, y: 0,width: UIScreen.cz_screenWidth(), height: 64));
    lazy var navItem = UINavigationItem();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI();
        loadData();

    }
    /// 加载数据 - 具体实现由子类实现
    func loadData() {
        //如果子类不实现任何方法，默认关闭刷新控件
        refreshControl?.endRefreshing();
    }

    override var title: String?{
        
        didSet{
            navItem.title = title;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - 按钮监听方法
extension JLBaseViewController{
    
    @objc fileprivate func login(){
        
        print("用户登录");
        
    }
    
    @objc fileprivate func regist(){
        
        print("用户注册");
        
    }
}


// MARK: - 设置界面
extension JLBaseViewController{
    
     fileprivate func setupUI(){
        
        //添加导航条
        view.addSubview(navigationBar);
        
        //取消自动缩进 - 如果隐藏了导航栏，会缩进20个点
        automaticallyAdjustsScrollViewInsets = false;
        
        //添加NavBar
        setUpNavBar();
        //添加表格
        userLogon ? setUpTableView():setupVistorView();
    }
    
    //- 设置navBar
    private func setUpNavBar(){
        
        // 将 item 设置给 bar
        navigationBar.items = [navItem];
        // 设置 navBar 的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6);
        // 设置系统按钮字体的渲染颜色
        navigationBar.tintColor = UIColor.orange;
        // 设置navbar 的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray];
    }
    
    //- 设置访客视图
    private func setupVistorView(){
        
        let vistorView = JLVistorView(frame: view.bounds);
        
        vistorView.vistorInfo = vistorInfoDic;
        
        view.insertSubview(vistorView, belowSubview: navigationBar);
        
        vistorView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside);
        vistorView.registerBtn.addTarget(self, action: #selector(regist), for: .touchUpInside);
        
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(regist));
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self, action: #selector(login));
    }
    
    //- 设置表格
    func setUpTableView(){
        
        tableView = UITableView(frame: view.bounds, style: .plain);
        //添加表格 插入在navigationBar的后面
        view.insertSubview(tableView!, belowSubview: navigationBar);
        
        //设置数据源&代理 -> 目的：让子类可以直接实现代理方法
        tableView?.delegate = self;
        tableView?.dataSource = self;
        
        tableView?.showsVerticalScrollIndicator = false;
        
        // 设置内容缩进(上左下右都要调整) 绑定取消系统缩进使用
        //tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0);
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, tabBarController?.tabBar.bounds.height ?? 49, 0);
        
        //设置刷新控件
        // 1> 实例化控件
        refreshControl = UIRefreshControl();
        // 2> 添加到表格视图
        tableView?.addSubview(refreshControl!);
        // 3> 添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged);
    }
    
}
// MARK: - UITableViewDataSource,UITableViewDelegate
extension JLBaseViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1. 判断 indexPath 是否是最后一行
        //    (indexPath.row(最后一行) / indexPath.section(最大))
        // 1> row
        let row = indexPath.row;
        // 2> section
        let section = tableView.numberOfSections - 1;
        
        if row < 0 || section < 0 {
            return;
        }
        
        // 3> 行数
        let count = tableView.numberOfRows(inSection: section);
        
        // 如果是最后一行，同时没有开始上拉刷新
        if row == (count - 1) && !isPuall {
            print("上拉刷新");
            isPuall = true;
            
            //开始刷新
            loadData();
        }
        
    }
}





