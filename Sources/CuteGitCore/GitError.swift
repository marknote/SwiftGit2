//
//  GitError.swift
//  MarkCanvas
//
//  Created by bill on 2024/7/16.
//

import Foundation

enum GitError: Error {
    case noPermssion
    case unknownGitProvider
    case invalidOauthtoken
    case uncommitedChangesBeforePulling
    case noCredential
    case invalidBranchName
    case invalidFileURL
    case noRemote
    case noTrackingBranch
    case notToDeleteCurrentBranch
    case notText
    case notFound
    case failToUpdateIgnore
}

extension GitError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noPermssion:
            return "No permission"
        case .unknownGitProvider:
            return "Unknown Git provider"
        case .uncommitedChangesBeforePulling:
            return "Please commit local changes first"
        case .noCredential:
            return "The operation cannot be completed: No credential found. Please select a different credential for the current repo."
        case .invalidOauthtoken:
            return """
Credential invalid. You may need:
- Re-login the git service
- Or select a different credential for the current repo.
"""
        case .invalidBranchName:
            return "Invalid branch name"
        case .invalidFileURL:
            return "Invalid file URL"
        case .noRemote:
            return "No remote"
        case .noTrackingBranch:
            return "No tracking branch"
        case .notToDeleteCurrentBranch:
            return "Current branch is not able to be deleted"
        case .notText:
            return "Not able to read binary data"
        case .notFound:
            return "Object not found"
        case .failToUpdateIgnore:
            return "Fail to update ignore rules"
        }
        
   
    
    }
}

