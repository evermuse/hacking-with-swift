//
//  Person.swift
//  Names to Faces
//
//  Created by Bryan Stoltman on 11/23/16.
//  Copyright © 2016 Sarva. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var name: String
    var image: String
    
    init(name:String, image:String) {
        
        self.name = name
        self.image = image
        
    }

}
