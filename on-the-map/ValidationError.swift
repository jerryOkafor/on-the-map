//
//  ValidationError.swift
//  on-the-map
//
//  Created by Jerry Hanks on 07/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import Foundation
class ValidationError: Error,LocalizedError {
    let message:String!
    
    init(message:String) {
        self.message = message
    }
    
    
    var localizedDescription: String{
        return "Validation Error: \(message!)"
    }
    
}
