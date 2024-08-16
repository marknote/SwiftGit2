//
//  Repository+.swift
//  MarkCanvas
//
//  Created by bill on 2024/7/18.
//

import Foundation
import SwiftGit2

public extension Repository {
    
    func listCommits() -> [Commit] {
        var commits: [Commit] = []
        let head = self.HEAD()
        switch (head) {
        case .success(let reference):
            print(reference)
            if let branch = reference as? Branch {
                let commitIterator = self.commits(in: branch)
                for commit in commitIterator {
                            switch commit {
                            
                            case let .success(c):
                                commits.append(c)
                            case let .failure(err):
                                print(err)
                            }
                        }
            }
            
        case .failure(let error):
            print(error)
        }
        return commits
    }
    
}
