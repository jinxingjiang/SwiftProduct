//
//  JLStatus.swift
//  firstSwiftProduct
//
//  Created by hai yue on 16/12/1.
//  Copyright © 2016年 coder JL. All rights reserved.
//

import UIKit
import YYModel

// 微博数据类型
class JLStatus: NSObject {
    
    // Int 类型，在64位机器是64位的，在32位机器是32位的
    var id:Int64 = 0;
    // 微博信息内容
    var text:String?;
    
    // 重写 description 的计算型属性
    override var description: String{
        return yy_modelDescription()
    }

}
