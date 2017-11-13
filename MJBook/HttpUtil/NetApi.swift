//
//  NetApi.swift
//  MJBook
//
//  Created by J1aDong on 2017/11/12.
//  Copyright © 2017年 J1aDong. All rights reserved.
//

import Foundation

enum NetApi{
    case getExplore(page:Int)
}

extension NetApi:Request{
    var path: String {
        switch self {
        case .getExplore(let page):
            return "explore?page="+String(page)
        }
    }
    var parameters: [String : Any]? {
        return nil
    }
    var hud: Bool {
        return false
    }
    var isReturnJSON:Bool{
        return false
    }
}
