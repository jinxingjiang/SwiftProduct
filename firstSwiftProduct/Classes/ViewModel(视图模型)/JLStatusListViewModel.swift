//
//  JLStatusListViewModel.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/12/1.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import Foundation

/// 微博数据列表视图模型
/*
 父类的选择
 
 - 如果类需要使用 “KVC” 或者字典转模型设置对象值，类就需要继承自 NSObject
 - 如果类只是包装一些代码逻辑（写了一些函数），可以不用任何父类，好处：更加轻量级
 - 提示：如果用 OC 写，一律都继承自 NSObject 即可
 
 使命：负责微博的数据处理
 */

private let maxPullUpTryTimes = 3;

class JLStatusListViewModel {
    
    // 微博模型数组懒加载
    lazy var statusList = [JLStatus]();
    
    // 上拉刷新错误次数
    private var pullUpErrorTimes = 0;
    
// MARK: - 加载模型方法
    func loadStatus(isPullUp: Bool = false, completion:@escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        
        // 判断是否是上拉刷新，同时检查刷新错误
        if isPullUp && pullUpErrorTimes > pullUpErrorTimes {
            
            completion(true,false);
            return;
        }
        
        // since_id 去除第一条的数组中的第一条微博的id
        let since_id = isPullUp ? 0 : (statusList.first?.id ?? 0);
        
        let max_id = !isPullUp ? 0 : (statusList.last?.id ?? 0)
        
        JLNetWorkTools.shared.statusList(since_id: since_id,max_id: max_id) { (list, isSuccess) in
            
            // 1. 字典转模型
            guard let array = NSArray.yy_modelArray(with: JLStatus.self, json: list ?? [])  as? [JLStatus] else{
                
                completion(isSuccess,false);
                return;
            }
            
            // 2. 拼接数据
            if isPullUp{
                
                self.statusList += array;
            }else
            {
                self.statusList = array + self.statusList;
            }
            
            // 3. 判断上拉刷新的数据量
            if isPullUp && array.count == 0{
                
                self.pullUpErrorTimes += 1;
                
                completion(isSuccess,false);
            }else{
                
                //完成回调
                print("array:\(self.statusList)");
                
                completion(isSuccess,true);
            }
            
        }
    }
}
