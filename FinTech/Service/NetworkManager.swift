//
//  NetworkManager.swift
//  FinTech
//
//  Created by Şükrü Şimşek on 21.03.2024.
//

import Foundation
import Alamofire
class NetworkManager {
    
    static let instance = NetworkManager()
    
    
    public func fetch<T:Codable> (_ method: HTTPMethod, url: String, requestModel: T?, model: T.Type, completion: @escaping(AFResult<Codable> ) -> Void ) {
        AF.request(url,
        method: method,
                   parameters: NetworkManager.toParameters(model: requestModel),
                   encoding: JSONEncoding.default,
                   headers: nil)
        .responseDecodable(of: model.self) { response in
            switch response.result {
            case .success(let responseModel):
                completion(.success(responseModel))
            case .failure(let error):
                print("Hata Network Manager içinde fetch kısmında \(error)")
                completion(.failure(error))
            }
        }
    }
    static func toParameters<T:Encodable>(model: T?) -> [String: AnyObject]? {
        if(model == nil) {
            return nil
        }
        let jsonData = modelToJson(model: model)
        let parameters = jsonToParameters(from: jsonData!)
        return parameters! as [String: AnyObject]
        
    }
    static func modelToJson<T:Encodable>(model:T)  -> Data? {
        return try! JSONEncoder().encode(model.self)
    }
    
    static func jsonToParameters(from data: Data) -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }
}
