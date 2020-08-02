//
//  Waste.swift
//  WasteManagement
//
//  Created by Arjun on 06/07/20.
//  Copyright © 2020 Arjun. All rights reserved.
//

import Foundation


class Waste: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case wasteCategory = "wasteType"
    }
    
    var name: String
    var wasteCategory: String
}
