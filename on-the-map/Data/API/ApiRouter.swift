//
//  ApiRouter.swift
//  on-the-map
//
//  Created by Jerry Hanks on 05/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import Foundation
typealias Parameters = [String: Codable]

enum HTTPMethod : String{
    case post = "POST"
    case get = "GET"
    case PUT = "PUT"
    case delete =  "DELETE"
}
enum ApiRouter{
    
    case createSession
    
    private var method : HTTPMethod{
        switch self {
        case .createSession:
            return .post
        default:
            return .get
        }
    }
    
    private var paramters : Parameters{
        switch self {
        case .createSession:
            return [:]
        default:
            return [:]
        }
    }
    
    
    private var path : String{
        switch self {
        case .createSession: return "session"
        }
    }
    
    func toUrlRequest() -> URLRequest{
        //convert the base URL
        let url = URL(string: ApiClient.baseUrl)!
        
        //creat a url reauest and append the path
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //set the method for request
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encoding a JSON body from a string, can also use a Codable struct
//        urlRequest.httpBody = try JSONEncoder().encode(paramters)

        
        return urlRequest
    }
    
}
