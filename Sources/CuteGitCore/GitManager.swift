//
//  GitManager.swift
//  MarkCanvas
//
//  Created by bill on 2024/7/10.
//

import Foundation
import SwiftGit2


public class GitManager {
    var service: LocalGitServiceProvider?
    
    
    public func ensureIgnoreFiles() {
        let docRoot = GitFileUtil.documentPath()
        let ignoreFile = docRoot + "/.gitignore"
        if !GitFileUtil.fileExists(ignoreFile) {
            let source = Bundle.main.path(forResource: "gitignore.txt", ofType: "")
            try! FileManager.default.copyItem(atPath: source!, toPath: ignoreFile)
        }
    }
    
    public init() {
        Repository.initialize_libgit2()
    }
    
    public func loadRepo(_ path: String) {
        service = LocalGitServiceProvider(root: URL(fileURLWithPath: path))
        //ensureIgnoreFiles()
    }
    
    public func status() async throws -> [StatusEntry] {
        guard let service = service else {
            return []
        }
        /*guard let repo = service.repository else {
            return []
        }
        let result = repo.status()
        switch (result) {
        case .success(let entries):
            return entries
        case .failure(let error):
            throw error
            
        }*/
        do {
            let entries = try await service.status()
            return entries
        } catch {
            print(error)
        }
        return []
    }
    
    public func stageAll() async throws -> Int {
        guard let service = service else {
            return 0
        }
        do {
            let entries = try await service.status()
            let unStagedFiles = entries.filter { item in
                return item.indexToWorkDir != nil// && item.indexToWorkDir!.newFile != nil
            }.map { item in
                return (item.indexToWorkDir!.newFile?.path ?? item.indexToWorkDir!.oldFile?.path) ?? ""
            }.filter { $0 != "" }
            try await service.stage(paths: unStagedFiles)
            return unStagedFiles.count
        } catch {
            print(error)
        }
        return 0
    }
    
    public func unstageAll() async throws -> Int {
        guard let service = service else {
            return 0
        }
        do {
            let entries = try await service.status()
            let stagedFiles = entries.filter { item in
                return item.headToIndex != nil// && item.indexToWorkDir!.newFile != nil
            }.map { item in
                return (item.headToIndex!.newFile?.path ?? item.headToIndex!.oldFile?.path) ?? ""
            }.filter { $0 != "" }
            try await service.unstage(paths: stagedFiles)
            return stagedFiles.count
        } catch {
            print(error)
        }
        return 0
    }
    

    
    public func createCommit(_ message: String = "message") async throws {
        guard let service = service else {
            return
        }
        try await service.commit(message: message)
    }
    
    public func commits() -> [Commit] {
        guard let service = service else {
            return []
        }
        guard let repo = service.repository else {
            return []
        }
        return repo.listCommits()
    }
    
    public func sync() async {
        print("sync")
        do {
            let staged = try await stageAll()
            if staged > 0 {
                try await createCommit()
            }
        } catch {
            print(error)
        }
    }
}
