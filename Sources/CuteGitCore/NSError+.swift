//
//  File.swift
//  MarkCanvas
//
//  Created by bill on 2024/7/14.
//

import Foundation
public extension NSError {
    convenience init(descriptionKey: String) {
        self.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: descriptionKey])
    }
}
