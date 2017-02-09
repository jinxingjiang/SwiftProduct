//
//  JLNetWorkTools+Extension .swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/12/1.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import Foundation

// MARK: - 封装微博的网络请求方法
extension JLNetWorkTools{
    
    
    /// 加载微博数据字典数组
    ///
    /// - parameter since_id:   返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    /// - parameter max_id:     返回ID小于或等于max_id的微博，默认为0
    /// - parameter completion: 完成回调[list: 微博字典数组/是否成功]
    func statusList(since_id: Int64, max_id: Int64, completion:@escaping (_ list:[[String:AnyObject]]?,_ isSuccess: Bool)->()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json";
        
        let params = ["since_id":since_id,"max_id":max_id > 0 ? max_id-1:0];
        
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?,completion: {(json, isSuccess) in
            
            let result = json?["statuses"] as? [[String: AnyObject]];
            
            completion(result,isSuccess);
            
            //print("isSuccess: \(isSuccess) \n list: \(json)");
            
        });
        
    }
    
// MARK: - 微博未读消息
    // 返回微博的未读数量
    func unreadCount(completion: @escaping (_ count: Int)->()) {
        
        guard let uid = uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json";
        
        let params = ["uid":uid];
        
        tokenRequest(URLString: urlString, parameters: params as [String : AnyObject]?){ (json,isSuccess) in
            
            let dict = json as? [String: AnyObject];
            let count = dict?["status"] as? Int;
            
            print("有\(count)条未读微博");
            completion(count ?? 0);
            
        }
        
    }
}
