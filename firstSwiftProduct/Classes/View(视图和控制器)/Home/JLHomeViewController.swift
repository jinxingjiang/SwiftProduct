//
//  JLHomeViewController.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/24.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit

// 定义全局常量,尽量使用 private 修饰，否则到处都可以访问
private let cellId = "cellID";

class JLHomeViewController: JLBaseViewController {
    
    /// 微博数据数组
    fileprivate lazy var listViewModel = JLStatusListViewModel();

    /// 加载数据
    override func loadData(){
        
        
        //根据父类的 isPuall 来判断是否上拉或下拉的操作
        self.listViewModel.loadStatus(isPullUp: self.isPuall) { (isSuccess,hasMorePullUp) in
            
            //结束刷新控件
            self.refreshControl?.endRefreshing();
            //恢复上拉刷新的标记
            self.isPuall = false;
            //刷新表格
            if hasMorePullUp{
                
                self.tableView?.reloadData();
            }
            print("加载数据结束")
            

        // 模拟延迟加载数据 -> dispatch_after
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
            
            }
        }
    }
    
    /// 显示好友
    @objc fileprivate func showFriends(){
    
        navigationController?.pushViewController(JLDemoViewController(), animated: true);
        
    }

}

/// MARK: -表格数据源方法
extension JLHomeViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. 取 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath);
        //2. 设置 cell
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text;
        //3. 返回 cell
        return cell;
    }
}

/// MARK：- 设置界面
extension JLHomeViewController{
    
    /// 重写父类的方法
    override func setUpTableView(){
        
        super.setUpTableView()
        
        //设置导航栏按钮
        navItem.leftBarButtonItem = UIBarButtonItem.init(leftTitle: "好友", target: self, action: #selector(showFriends));
        
        //注册 cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId);
        
        tableView?.rowHeight = 60;
        
    }
    
}









