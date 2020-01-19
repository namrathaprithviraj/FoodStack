//
//  MenuItemsManager.swift
//  Restaurant
//
//  Created by AppsFoundation on 8/27/15.
//  Copyright © 2015 AppsFoundation. All rights reserved.
//

import UIKit

class MenuItemsManager: NSObject {
    
    static let sharedManager = MenuItemsManager()
    
    private override init() {}
    
    // MARK: - Public Methods
    func loadData() -> [MenuItem] {
        let path = Bundle.main.path(forResource: "MenuItems", ofType: "plist")
        if let dataArray = NSArray(contentsOfFile: path!) {
            return constructMenuItemsFromArray(array: dataArray)
        } else {
            return [MenuItem]()
        }
    }
    
    // MARK: - Private Methods
    private func constructMenuItemsFromArray(array: NSArray) -> [MenuItem] {
        var resultItems = [MenuItem]()
        
        for object in array {
            let obj = object as! NSDictionary
            let name = obj["name"] as! String
            
            let qty = obj["qty"] as! Int
            let expiry = obj["expiry"] as! String
            if let image = obj["image"] as? UIImage {
                let loadedMenuItem = MenuItem(name: name, image: image, qty: qty, expiry:expiry )
                resultItems.append(loadedMenuItem)
            }

        }
        return resultItems
    }
}
