//
//  WasteListManager.swift
//  WasteManagement
//
//  Created by Arjun on 06/07/20.
//  Copyright © 2020 Arjun. All rights reserved.
//

import Foundation


class WasteListManager {
        
    static let shared: WasteListManager = WasteListManager()
    var wastes: [Waste]!
    private var wasteMap = [String: Waste]()
        
    private init() {
        do {
            guard let wastesFilepath = Bundle.main.url(forResource: "WasteItem", withExtension: "plist") else { return }
            
            let data = try Data(contentsOf: wastesFilepath)
            let plistDecoder = PropertyListDecoder()
            wastes = try plistDecoder.decode([Waste].self, from: data)
            
            for waste in wastes {
                wasteMap[waste.name] = waste
            }
        } catch {
            fatalError("Error occured in reading the WasteItem.plist file: \(error.localizedDescription)")
        }
    }
        
//    func video(withName name: String) -> Video {
//        guard let video = videoMap[name] else {
//            fatalError("Could not find Video with name: \(name)")
//        }
//        return video
//    }
}
