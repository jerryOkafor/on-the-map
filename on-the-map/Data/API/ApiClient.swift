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

    class func doRequest<ResponseType: Decodable>(request: URLRequest,responseType:ResponseType.Type, secureResponse:Bool = true, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
    
      
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

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
            guard let status = (response as? HTTPURLResponse)?.statusCode, status != 400 else {
                DispatchQueue.main.async {
                    completion(nil, ApiError.badRequest)
                }
                return
            }
            
            
            //check for unathorised
            guard status != 401 else{
                DispatchQueue.main.async {
                    completion(nil, ApiError.unathorized)
                }
                return
            }
            
            //check for unathorised
            guard status != 403 else{
                DispatchQueue.main.async {
                    completion(nil, ApiError.unathorized)
                }
                return
            }
            
            //check for method change
            guard status != 405 else {
                DispatchQueue.main.async {
                    completion(nil, ApiError.methodNotFound)
                }
                return
            }
            
            //Check for URL changed
            guard status != 405 else {
                DispatchQueue.main.async {
                    completion(nil, ApiError.urlChanged)
                }
                return
            }
            
            //Chack Server error
            guard status != 500 else {
                DispatchQueue.main.async {
                    completion(nil, ApiError.internalServerError)
                }
                return
            }
            
            
            // Did we get a successful 2XX response?
            guard status >= 200 && status <= 299 else {
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
                let newData:Data!
                
                if secureResponse{
                     newData = data.subdata(in: 5..<data.count)
                }else{
                     newData = data
                }
               
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
    
    
    class func doRequestWithData<RequestType: Encodable,ResponseType: Decodable>(request: URLRequest,requestType:RequestType.Type,responseType:ResponseType.Type,body: RequestType,secureResponse:Bool = true, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        var urlRequest =  request
        urlRequest.httpBody = try! JSONEncoder().encode(body)
    
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
                DispatchQueue.main.async {
                    completion(nil, ApiError.unathorized)
                }
                return
            }
            
            //check for unathorised
            guard status != 401 else{
                DispatchQueue.main.async {
                    completion(nil, ApiError.unathorized)
                }
                return
            }
            
            //check for unathorised
            guard status != 403 else{
                DispatchQueue.main.async {
                    completion(nil, ApiError.unathorized)
                }
                return
            }
            
            //check for method change
            guard status != 405 else {
                DispatchQueue.main.async {
                    completion(nil, ApiError.methodNotFound)
                }
                return
            }
            
            //Check for URL changed
            guard status != 405 else {
                DispatchQueue.main.async {
                    completion(nil, ApiError.urlChanged)
                }
                return
            }
            
            //Chack Server error
            guard status != 500 else {
                DispatchQueue.main.async {
                    completion(nil, ApiError.internalServerError)
                }
                return
            }
            
            
            // Did we get a successful 2XX response?
            guard status >= 200 && status <= 299 else {
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
                
                let newData:Data!
                
                if secureResponse{
                    newData = data.subdata(in: 5..<data.count)
                }else{
                    newData = data
                }
                
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
    case badRequest = 400
    case unathorized = 401
    case forbidden = 403
    case methodNotFound = 405
    case urlChanged = 410
    case internalServerError = 500
}

extension ApiError : LocalizedError{
    var localizedDescription: String{
        switch self {
        case .networkError:return "Network error, pleaese try again"
        case .badRequest:return "Invalid paramters sent"
        case .unathorized:return "Invalide Credential, username or password incorrect"
        case .forbidden: return "User not authorised"
        case .methodNotFound:return "Method not found"
        case .urlChanged:return "Request URL changed"
        case .internalServerError:return "An error ocurred,please try again later."
        }
    }
}
