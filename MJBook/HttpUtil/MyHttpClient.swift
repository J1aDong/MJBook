//
//  MyHttpClient.swift
//  MJBook
//
//  Created by J1aDong on 2017/11/12.
//  Copyright © 2017年 J1aDong. All rights reserved.
//
import Foundation
import RxSwift
import Alamofire
import SVProgressHUD

let BaseUrl = "https://www.gitbook.com/"

enum MyHttpError : Swift.Error {
    case HTTPFailed
    case MapperError
    case CustomError(msg:String,code:Int)
    
    func show() -> MyHttpError{
        switch self {
        case .HTTPFailed:
            SVProgressHUD.showError(withStatus: "HttpFailed")
            break
        case .MapperError:
            SVProgressHUD.showError(withStatus: "MapperError")
            break
        case .CustomError(let msg, _):
            SVProgressHUD.showError(withStatus: "\(msg)")
            break
        }
        return self
    }
}

let SUCCESSCODE    = 1

let RESULT_CODE    = "code"
let RESULT_MESSAGE = "msg"
let RESULT_DATA    = "result"


public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var hud: Bool { get }
    var isReturnJSON:Bool {get}
}

extension Request {
    var hud: Bool {
        return true
    }
    
    var method: HTTPMethod {
        return HTTPMethod.get
    }
    
    var isReturnJSON: Bool{
        return true
    }
}

protocol RequestClient {
    var host: String { get }
    func send<T: Request>(_ r: T) -> Observable<[String : Any]>
}

public struct MyHttpClient:RequestClient{
    var host: String {
        return BaseUrl
    }
    
    func send<T : Request>(_ r: T) -> Observable<[String : Any]> {
        return Observable<[String : Any]>.create({ (observer) -> Disposable  in
            
            print("\(self.host)\(r.path) \(r.method)")
            
            if (r.hud){
                SVProgressHUD.show()
            }
            
            if(r.isReturnJSON){
                Alamofire.request(URL.init(string: "\(self.host)\(r.path)")!, method: r.method, parameters: r.parameters).responseJSON { (response) in
                    
                    SVProgressHUD.dismiss()
                    
                    switch response.result {
                    case .success(_):
                        if let json = response.result.value as? [String : Any] {
                            if let code = json[RESULT_CODE] as? Int {
                                if code == SUCCESSCODE {
                                    observer.onNext(json[RESULT_DATA] as! [String : Any])
                                    observer.onCompleted()
                                } else {
                                    let message = json[RESULT_MESSAGE] as! String
                                    observer.onError(MyHttpError.CustomError(msg: message, code: code).show())
                                }
                            } else {
                                observer.onError(MyHttpError.MapperError.show())
                            }
                        }else{
                            observer.onError(MyHttpError.MapperError.show())
                        }
                    case .failure(_):
                        observer.onError(MyHttpError.HTTPFailed.show())
                    }
                }
            }else{
                Alamofire.request(URL.init(string: "\(self.host)\(r.path)")!, method: r.method, parameters: r.parameters).responseString(completionHandler: { (response) in
                    SVProgressHUD.dismiss()
                    
                    if response.result.error != nil{
                        print(response.result.error!)
                        observer.onError(MyHttpError.HTTPFailed.show())
                    }else{
                        observer.onNext(["result":response.result.value!])
                    }
                })
            }
            return Disposables.create {
                
            }
        })
    }
}
