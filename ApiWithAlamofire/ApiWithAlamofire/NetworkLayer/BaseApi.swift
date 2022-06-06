//
//  BaseApi.swift
//  ApiWithAlamofire
//
//  Created by Ahmed Fayeq on 08/01/2022.
//

import Foundation
import Alamofire

class BaseApi<T:TargetType> {
    
    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completion: @escaping (Result<M?, NSError>)-> Void){
        let method  = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params  = buildParams(task: target.task)
        AF.request(target.baseURL + target.path, method: method, parameters:params.0, encoding: params.1, headers: headers).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(NSError()))
                return
            }
            if statusCode == 200 {
                guard let jsonResponse = try? response.result.get() else {
                    completion(.failure(NSError()))
                    return
                }
                guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    completion(.failure(NSError()))
                    return
                }
                guard let jsonResponseObject = try? JSONDecoder().decode(M.self, from: jsonData) else {
                    completion(.failure(NSError()))
                    return
                }
                completion(.success(jsonResponseObject))
                
            }else{
                completion(.failure(NSError())) // 404 / 401 notFound, unAuthorized
            }
        }
    }
    
    
    private func buildParams(task: Task)-> ([String: Any], ParameterEncoding){
        switch task {
        case .requestPlain:
            return([:], URLEncoding.default)
        case .requestParmeters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
}
