//
//  Network.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/9/24.
//

import Foundation
import UIKit
import AdSupport
import CommonCrypto
import Alamofire
import Moya

let domain = "https://open.staging.qingting.fm" // 测试环境域名
let xmlyUrl = "https://api.ximalaya.com"

struct MyRadioNetwork {
    static func request(target: TestType) {
        let configuration = NetworkLoggerPlugin.Configuration(logOptions: .requestMethod)
        let myNetworkLoggerPlugin = NetworkLoggerPlugin(configuration: configuration)

        
        let provider = MoyaProvider<TestType>(plugins: [myNetworkLoggerPlugin])
        provider.request(target) { result in
            switch result {
            case let .success(res):
                print("qq")
            case let .failure(err):
                print(err)
            }
            
        }
        
    }
}

enum TestType {
    case getAuthCode // 获取授权码
    case auth // 授权
    case channellives // 获取广播电台列表
    case test
}

extension TestType: TargetType {
    var baseURL: URL {
        URL(string: xmlyUrl)!
    }
    
    var path: String {
        switch self {
        case .getAuthCode:
            return "/auth/v7/authorize"
        case .auth:
            return ""
        case .channellives:
            return "/media/v7/channellives"
        case .test:
            return "/live/radio_categories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAuthCode:
            return .get
        case .auth:
            return .post
        case .channellives:
            return .get
        case .test:
            return .get
        }
    }
    
    var task: Moya.Task {
        var parameters = [String: Any]()
        switch self {
        case .getAuthCode:
            parameters["response_type"] = "code"
            parameters["client_id"] = "1234"
        case .auth:
            parameters[""] = ""
        case .channellives: break
        case .test:
            parameters["app_key"] = "d11683974a36dc84adece5d71cc4ad87"
            parameters["client_os_type"] = "1"
            parameters["nonce"] = String.randomStr(len: 30)
            parameters["timestamp"] = Date().timeIntervalSince1970 * 1000
            parameters["device_id"] = UUID().uuidString
            parameters["device_id_type"] = "UUID"
            parameters["server_api_version"] = "1.0.0"
            
            // 1.将参数字典排序
            let sorted = parameters.sorted(by: {$0.0 < $1.0})
            // 2.将排序后的参数键值对用&拼接
            let queryString = sorted.map { key, value in
                return "\(key)=\(value)"
            }.joined(separator: "&")
            // 3.Base64编码
            if let data = queryString.data(using: .utf8) {
                let base64EncodedStr = data.base64EncodedString()
                // 4.准备下一步需要的HMAC-SHA1哈希key
                let hash_key = "3194a8431653849488c0b94ef4f86284"
                // 5.使用sha1Key对base64EncodedStr进行HMAC-SHA1哈希得到字节数组
                if let sha1ResultBytes = hmacSHA1(key: hash_key, message: base64EncodedStr) {
                    let sig = md5(data: sha1ResultBytes)
                    // 6.对上面得到的sha1ResultBytes进行MD5得到32位字符串，即为sig
                    parameters["sig"] = sig
                }
            }
            
        }
        return Moya.Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAuthCode:
//            return [
//                "QT-Device-Id": UUID().uuidString, // 设备号
//                "QT-Access-Token": "", // 当前用户
//                "QT-User-Id": "", // 用户ID
//                "QT-Device-OS": "ios",
//                "QT-Device-OS-Version": UIDevice.current.systemVersion,
//                "QT-App-Version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
//                "QT-Device-Model": UIDevice.current.model
//            ]
            return nil
        case .auth:
            return [:]
        default:
            return nil
        }
    }
    
    
}

func hmacSHA1(key: String, message: String) -> Data? {
    if let keyData = key.data(using: .utf8), let messageData = message.data(using: .utf8) {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        keyData.withUnsafeBytes { keyBytes in
            messageData.withUnsafeBytes { messageBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyBytes.baseAddress, keyBytes.count, messageBytes.baseAddress, messageBytes.count, &digest)
            }
        }

        return Data(digest)
    }
    return nil
}

func md5(data: Data) -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    _ = data.withUnsafeBytes { (buffer) -> Bool in
        if let baseAddress = buffer.baseAddress, buffer.count > 0 {
            CC_MD5(baseAddress, CC_LONG(buffer.count), &digest)
        }
        return true
    }

    let md5String = digest.map { String(format: "%02hhx", $0) }.joined()
    return md5String
}

extension String{
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
}
