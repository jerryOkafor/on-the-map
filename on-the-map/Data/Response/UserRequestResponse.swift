//
//  UserRequestResponse.swift
//  on-the-map
//
//  Created by Jerry Hanks on 09/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import Foundation
struct User:Codable {
    let firstName:String
    let lastName:String
    let key:String
    let nickName:String
    let imageUrl:String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName =  "last_name"
        case key = "key"
        case nickName = "nickname"
        case imageUrl = "_image_url"
    }
    
    
}
struct UserRequestResponse:Codable {
    let user : User
}
