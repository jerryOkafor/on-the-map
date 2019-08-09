//
//  CreateSession.swift
//  on-the-map
//
//  Created by Jerry Hanks on 06/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import Foundation
struct Credential:Codable {
    let userName:String
    let password:String
}
struct CreatSession : Codable{
    let udacity:Credential
}
