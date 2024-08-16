//
//  UserDefaults+Hosts.swift
//  MarkCanvas
//
//  Created by bill on 2024/7/14.
//

import Foundation



public extension UserDefaults {
    
    var gitCredentialsLookupEntries: [GitCredentials] {
        get {
            if let data = self.data(forKey: "git.credentials.entries"),
                let array = try? PropertyListDecoder().decode(
                    [GitCredentials].self, from: data)
            {
                return array
            } else {
                return []
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                self.set(data, forKey: "git.credentials.entries")
            }
        }
    }
}
