//
//  ApiClient.swift
//  on-the-map
//
//  Created by Jerry Hanks on 05/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import Foundation
class ApiClient {
    static let baseUrl = "https://onthemap-api.udacity.com/v1/"

    class func request<RequestType: Encodable,ResponseType: Decodable>(request: URLRequest,requestType:RequestType.Type,responseType:ResponseType.Type,body: RequestType? = nil, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        var urlRequest =  request
        
        if let body  = body{
            urlRequest.httpBody = try! JSONEncoder().encode(body)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
           
            //check error for early exit, non http error
            guard error  == nil else{
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        completion(nil, ApiError.networkError)
                    }
                    completion(nil, error)
                }
                return
            }
            
            // Did we get a successful 403 response?
            guard let status = (response as? HTTPURLResponse)?.statusCode, status != 403 else {
                print("Wrong response status code (403)")
                DispatchQueue.main.async {
                    completion(nil, ApiError.invalidCredential)
                }
                return
            }
            
            // Did we get a successful 2XX response?
            guard status >= 200 && status <= 299 else {
                print("Wrong response status code \(status)")
                DispatchQueue.main.async {
                    completion(nil, ApiError.networkError)
                }
                return
            }
            
            //ensure that we have data
            guard let data = data else {
                DispatchQueue.main.async {
                     completion(nil, ApiError.networkError)
                }
                return
            }
            
            //try to decode the response
            let decoder = JSONDecoder()
            do {
                let newData = data.subdata(in: 5..<data.count)
                
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                //error decoding response
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
}


enum ApiError :Int, Error{
    case networkError = 0
    case invalidCredential = 403
    case internalServerError = 500
}

extension ApiError : LocalizedError{
    var localizedDescription: String{
        switch self {
        case .networkError:return "Network error, pleaese try again"
        case .invalidCredential:return "Invalide Credential, username or password incorrect"
        default:return "Unknow API error"
        }
    }
}
