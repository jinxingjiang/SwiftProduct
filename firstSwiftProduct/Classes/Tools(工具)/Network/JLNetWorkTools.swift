//
//  JLNetWorkTools.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/11/30.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit
import AFNetworking

/// swift 的枚举支持任意数据类型
/// switch / enum 在 OC 中只支持整数
enum JLHTTPMethod{
    case GET;
    case POST;
}

// MARK: - 网络管理工具
class JLNetWorkTools: AFHTTPSessionManager {
    
    /// 静态区 / 常量 / 闭包    <单例模式>
    /// 在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared = JLNetWorkTools();
    
    /// 访问令牌 所有的网络请求，都基于此令牌(登录除外)
    /// 访问令牌有时限
    var accessToken:String? = "2.00AQsMWD0TtJ1R1837326c98FhX_wC";
    
    // 用户的微博ID
    var uid: String? = "13781329840";
 
// MARK: - 建立tokenRequest方法，处理token字典
    //专门负责 “token” 的网络请求
    func tokenRequest(method: JLHTTPMethod = .GET,
                      URLString: String,
                      parameters: [String:AnyObject]?,
                      completion:@escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        // 处理 token 字典
        // 0> 判断 token 是否为nil，为 nil 直接返回
        guard let token = accessToken else {
            
            print("没有 token 需要登录");
            // FIXME: 发送通知，提示用户登录

            completion(nil,false);
            
            return
        }
        
        // 1> 判断 参数字典是否存在，如果为 nil，应该新建一个字典
        var parameters = parameters;
        if parameters == nil {
            // 实例化字典
            parameters = [String:AnyObject]();
        }
        
        // 2> 设置参数字典，代码在此处字典一定有值
        parameters!["access_token"] = token as AnyObject?;
        
        // 调取 request 发起真正的网络请求方法
        request(URLString: URLString, parameters: parameters, completion: completion);
        
    }
    
    
// MARK: - 封装 AFN 的 GET / POST 请求
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 完成回调[json(字典／数组), 是否成功]
    func request(method: JLHTTPMethod = .GET,
                 URLString: String,
                 parameters: [String:AnyObject]?,
                 completion:@escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        
        print("\(URLString)");
        
        // 成功回调
        let success = { (task: URLSessionDataTask, json: Any?)->() in
    
            completion(json as AnyObject?,true);
    
        }
    
        // 失败回调
        let failure = { (task: URLSessionDataTask?, error: Error)->() in
    
            
            //针对 token 过期处理
            if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                print("Token 过期了");
                
                // FIXME: 发送通知，提示用户再次登录(本方法不知道被谁调用，谁接收到通知，谁处理！)
                
                
            }
            
            print("网络请求错误\(error)");
            
            completion(nil, false);
        }
        
        if method == .GET {
            
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure);
            
        }else{
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure);
            
        }
        
    }

}

