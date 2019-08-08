//
//  LocationResponse.swift
//  on-the-map
//
//  Created by Jerry Hanks on 08/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import Foundation
struct Location : Codable {
    let firstName:String!
    let lastName:String!
    let longitude:Double!
    let latitude:Double
    let mapString:String!
    let mediaURL:String!
    let uniqueKey:String!
    let objectId:String!
    let createdAt:String!
    let updatedAt:String!
}
struct LocationResponse : Codable {
    let results : [Location]!
}
