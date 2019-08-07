//
//  CreateSessionResponse.swift
//  on-the-map
//
//  Created by Jerry Hanks on 07/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import Foundation
struct Account:Codable {
    let registered:Bool!
    let key:String!
}

struct Session:Codable {
    let id:String!
    let expiration:String!
}

struct CreatSessionResponse : Codable {
    let account:Account!
    let session:Session!
}
