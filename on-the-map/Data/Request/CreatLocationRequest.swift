//
//  CreatLocationRequest.swift
//  on-the-map
//
//  Created by Jerry Hanks on 08/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import Foundation

struct CreateLocationRequest : Codable {
    let firstName:String
    let lastName:String
    let longitude:Double
    let latitude:Double
    let mapString:String
    let mediaURL:String
    let uniqueKey:String
}
