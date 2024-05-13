//
//  XMNetwork.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/10/10.
//

import Foundation
import Moya
import AdSupport
import AppTrackingTransparency

struct XMNetwork {
    
    static let shared = XMNetwork()
    
    var provider: MoyaProvider<XMNetworkType> {
        let configuration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let myNetworkLoggerPlugin = NetworkLoggerPlugin(configuration: configuration)
        
        let provider = MoyaProvider<XMNetworkType>(plugins: [myNetworkLoggerPlugin])
        return provider
    }
    
    static func request(target: XMNetworkType, completion: @escaping Completion) {
        let configuration = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let myNetworkLoggerPlugin = NetworkLoggerPlugin(configuration: configuration)
        
        let provider = MoyaProvider<XMNetworkType>(plugins: [myNetworkLoggerPlugin])
        provider.request(target, completion: completion)
    }
}

enum XMNetworkType {
    case radio_categories // 获取广播电台的分类
    case get_radios_by_category(id: Int, page: Int = 1, count: Int = 200) // 获取电台分类下的广播电台
    case get_playing_program(radio_id: Int) // 获取某个电台正在广播的节目
    case provinces // 获取广播省市列表
    case radios(radio_type: Int, province_code: Int? = nil, page: Int = 1, count: Int = 20) // 获取广播电台省市列表
    case schedules(radio_id: Int, weekday: Int?) // 获取某个广播电台某一天的节目排期的列表
    case cities(province_code: Int) // 获取某省份城市列表
    case get_radios_by_city(city_code: Int, page: Int = 1, count: Int = 20) // 获取某个城市下的电台列表
    case get_radios_by_ids(ids: String) // 根据电台ID，批量获取电台列表
}

extension XMNetworkType: TargetType {
    var baseURL: URL {
        URL(string: "https://api.ximalaya.com")!
    }
    
    var path: String {
        switch self {
        case .radio_categories:
            return "/live/radio_categories"
        case .get_radios_by_category:
            return "/live/get_radios_by_category"
        case .get_playing_program:
            return "/live/get_playing_program"
        case .provinces:
            return "/live/provinces"
        case .radios:
            return "/live/radios"
        case .schedules:
            return "/live/schedules"
        case .cities:
            return "/live/cities"
        case .get_radios_by_city:
            return "/live/get_radios_by_city"
        case .get_radios_by_ids:
            return "/live/get_radios_by_ids"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        var parameters = [String: Any]()
        parameters["app_key"] = "d11683974a36dc84adece5d71cc4ad87"
        parameters["client_os_type"] = "1"
        parameters["nonce"] = String.randomStr(len: 30)
        parameters["timestamp"] = CLongLong(round(Date().timeIntervalSince1970 * 1000))
        ATTrackingManager .requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
                parameters["device_id"] = UUID().uuidString
                parameters["device_id_type"] = "UUID"
            case .restricted:
                parameters["device_id"] = UUID().uuidString
                parameters["device_id_type"] = "UUID"
            case .denied:
                parameters["device_id"] = UUID().uuidString
                parameters["device_id_type"] = "UUID"
            case .authorized:
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                parameters["device_id"] = idfa
                parameters["device_id_type"] = "IDFA"
            default:
                break
            }
        }
        parameters["server_api_version"] = "1.0.0"
        switch self {
        case .radio_categories: break
        case .get_radios_by_category(let id, let page, let count):
            parameters["radio_category_id"] = id
            parameters["page"] = page
            parameters["count"] = count
        case .get_playing_program(let radio_id):
            parameters["radio_id"] = radio_id
        case .provinces: break
        case .radios(let radio_type, let province_code, let page, let count):
            parameters["radio_type"] = radio_type //电台类型：1-国家台，2-省市台，3-网络台
            parameters["province_code"] = province_code // 省份代码，radio_type为2时不能为空
            parameters["page"] = page // 返回第几页，必须大于等于1，不填默认为1
            parameters["count"] = count // 每页多少条，默认20，最多不超过200
        case .schedules(radio_id: let radio_id, weekday: let weekday):
            parameters["radio_id"] = radio_id
            parameters["weekday"] = weekday
        case .cities(province_code: let province_code):
            parameters["province_code"] = province_code
        case .get_radios_by_city(city_code: let city_code, page: let page, count: let count):
            parameters["city_code"] = city_code
            parameters["page"] = page
            parameters["count"] = count
        case .get_radios_by_ids(ids: let ids):
            parameters["ids"] = ids
        }
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
        return Moya.Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
