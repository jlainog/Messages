//
//  SessionCache.swift
//  Messages
//
//  Created by Luis Ramirez on 3/21/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation

class SessionCache: NSObject, NSCoding {
    var user = User(identifier: "Default", name: "Default") {
        didSet {
            self.saveSession()
        }
    }
    
    private static var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return (url?.appendingPathComponent("Data").path)!
    }
    
    static let sharedInstance : SessionCache = {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: SessionCache.filePath) as? SessionCache {
            return data
        }
        
        return SessionCache()
    }()
    
    required init?(coder aDecoder: NSCoder) {
        guard let user = aDecoder.decodeObject(forKey: "user") as? User else { return nil }
        
        self.user = user
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.user, forKey: "user")
    }
    
    private override init (){ }
    
    private func saveSession() {
        NSKeyedArchiver.archiveRootObject(self, toFile: SessionCache.filePath)
    }
    
}
