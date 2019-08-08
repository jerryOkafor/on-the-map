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
    case deleteSession
    case locations
    case createLocation
    
    private var method : HTTPMethod{
        switch self {
        case .createSession:
            return .post
        case .createLocation: return .post
        case .deleteSession: return .delete
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
        case .deleteSession: return "session"
        case .locations:return "StudentLocation?order=-updatedAt&limit=80"
        case .createLocation:return "StudentLocation"
        }
    }
    
    func toUrlRequest() -> URLRequest{
        //convert the base URL
        let url = URL(string: "\(ApiClient.baseUrl)\(path)")!
        
        //append the path
        let urlwithPath = URL(string: url.absoluteString.removingPercentEncoding!)!
        
        print(urlwithPath)
        
        //creat a url reauest and append the path
        var urlRequest = URLRequest(url: urlwithPath)
        
        //set the method for request
        urlRequest.httpMethod = method.rawValue

        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            urlRequest.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }
    
}
