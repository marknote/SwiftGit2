//
//  Diffs.swift
//  SwiftGit2
//
//  Created by Jake Van Alstyne on 8/20/17.
//  Copyright © 2017 GitHub, Inc. All rights reserved.
//

import libgit2

public struct StatusEntry {
    public var status: Diff.Status
    public var headToIndex: Diff.Delta?
    public var indexToWorkDir: Diff.Delta?
    
    public init(from statusEntry: git_status_entry) {
        self.status = Diff.Status(rawValue: statusEntry.status.rawValue)
        
        if let htoi = statusEntry.head_to_index {
            self.headToIndex = Diff.Delta(htoi.pointee)
        }
        
        if let itow = statusEntry.index_to_workdir {
            self.indexToWorkDir = Diff.Delta(itow.pointee)
        }
    }
}

public struct Diff {
    
    /// The set of deltas.
    public var deltas = [Delta]()
    
    public struct Delta {
        public static let type = GIT_OBJECT_REF_DELTA
        
        public var status: Status
        public var flags: Flags
        public var oldFile: File?
        public var newFile: File?
        
        public init(_ delta: git_diff_delta) {
            self.status = Status.from(delta.status)
            self.flags = Flags(rawValue: delta.flags)
            self.oldFile = File(delta.old_file)
            self.newFile = File(delta.new_file)
        }
    }
    
    public struct File {
        public var oid: OID
        public var path: String
        public var size: Int64
        public var flags: Flags
        
        public init(_ diffFile: git_diff_file) {
            self.oid = OID(diffFile.id)
            let path = diffFile.path
            self.path = path.map(String.init(cString:))!
            self.size = Int64(diffFile.size)
            self.flags = Flags(rawValue: diffFile.flags)
        }
    }
    
    public struct Status: OptionSet {
        // This appears to be necessary due to bug in Swift
        // https://bugs.swift.org/browse/SR-3003
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        public let rawValue: UInt32
        
        
        
        /*public static let current                = Status(rawValue: GIT_STATUS_CURRENT.rawValue)
         public static let indexNew               = Status(rawValue: GIT_STATUS_INDEX_NEW.rawValue)
         public static let indexModified          = Status(rawValue: GIT_STATUS_INDEX_MODIFIED.rawValue)
         public static let indexDeleted           = Status(rawValue: GIT_STATUS_INDEX_DELETED.rawValue)
         public static let indexRenamed           = Status(rawValue: GIT_STATUS_INDEX_RENAMED.rawValue)
         public static let indexTypeChange        = Status(rawValue: GIT_STATUS_INDEX_TYPECHANGE.rawValue)
         public static let workTreeNew            = Status(rawValue: GIT_STATUS_WT_NEW.rawValue)
         public static let workTreeModified       = Status(rawValue: GIT_STATUS_WT_MODIFIED.rawValue)
         public static let workTreeDeleted        = Status(rawValue: GIT_STATUS_WT_DELETED.rawValue)
         public static let workTreeTypeChange     = Status(rawValue: GIT_STATUS_WT_TYPECHANGE.rawValue)
         public static let workTreeRenamed        = Status(rawValue: GIT_STATUS_WT_RENAMED.rawValue)
         public static let workTreeUnreadable     = Status(rawValue: GIT_STATUS_WT_UNREADABLE.rawValue)
         public static let ignored                = Status(rawValue: GIT_STATUS_IGNORED.rawValue)
         public static let conflicted             = Status(rawValue: GIT_STATUS_CONFLICTED.rawValue)*/
        // https://github.com/SwiftGit2/SwiftGit2/issues/177
        /**GIT_DELTA_UNMODIFIED = 0,  /**< no changes */
         GIT_DELTA_ADDED = 1,       /**< entry does not exist in old version */
         GIT_DELTA_DELETED = 2,       /**< entry does not exist in new version */
         GIT_DELTA_MODIFIED = 3,    /**< entry content changed between old and new */
         GIT_DELTA_RENAMED = 4,     /**< entry was renamed between old and new */
         GIT_DELTA_COPIED = 5,      /**< entry was copied from another old entry */
         GIT_DELTA_IGNORED = 6,     /**< entry is ignored item in workdir */
         GIT_DELTA_UNTRACKED = 7,   /**< entry is untracked item in workdir */
         GIT_DELTA_TYPECHANGE = 8,  /**< type of entry changed between old and new */
         GIT_DELTA_UNREADABLE = 9,  /**< entry is unreadable */
         GIT_DELTA_CONFLICTED = 10, /**< entry in the index is conflicted */**/
        public static let unmodified               = Status(rawValue: GIT_DELTA_UNMODIFIED.rawValue)
        public static let added               = Status(rawValue: GIT_DELTA_ADDED.rawValue)
        public static let deleted               = Status(rawValue: GIT_DELTA_DELETED.rawValue)
        public static let modified               = Status(rawValue: GIT_DELTA_MODIFIED.rawValue)
        public static let renamed               = Status(rawValue: GIT_DELTA_RENAMED.rawValue)
        public static let copied               = Status(rawValue: GIT_DELTA_COPIED.rawValue)
        public static let ignored               = Status(rawValue: GIT_DELTA_IGNORED.rawValue)
        public static let untracked               = Status(rawValue: GIT_DELTA_UNTRACKED.rawValue)
        public static let typechange               = Status(rawValue: GIT_DELTA_TYPECHANGE.rawValue)
        public static let unreachable               = Status(rawValue: GIT_DELTA_UNREADABLE.rawValue)
        public static let conflicted               = Status(rawValue: GIT_DELTA_CONFLICTED.rawValue)
        
        static func from(_ rawValue: git_delta_t) -> Status {
            switch rawValue {
            case GIT_DELTA_UNMODIFIED:
                return Status.unmodified
            case    GIT_DELTA_ADDED:
                return Status.added
            case    GIT_DELTA_DELETED :
                return Status.deleted
                /**< entry does not exist in new version */
            case    GIT_DELTA_MODIFIED:
                return Status.modified
            case    GIT_DELTA_RENAMED:
                return Status.renamed
            case    GIT_DELTA_COPIED:
                return Status.copied
            case    GIT_DELTA_IGNORED:
                return Status.ignored
            case    GIT_DELTA_UNTRACKED:
                return Status.untracked
            case    GIT_DELTA_TYPECHANGE:
                return Status.typechange
            case    GIT_DELTA_UNREADABLE:
                return Status.unreachable
            case GIT_DELTA_CONFLICTED:
                return Status.conflicted
            default:
                return Status.unmodified
            }
            
        }
    }
    
    public struct Flags: OptionSet {
        // This appears to be necessary due to bug in Swift
        // https://bugs.swift.org/browse/SR-3003
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        public let rawValue: UInt32
        
        public static let binary     = Flags([])
        public static let notBinary  = Flags(rawValue: 1 << 0)
        public static let validId    = Flags(rawValue: 1 << 1)
        public static let exists     = Flags(rawValue: 1 << 2)
    }
    
    /// Create an instance with a libgit2 `git_diff`.
    public init(_ pointer: OpaquePointer) {
        for i in 0..<git_diff_num_deltas(pointer) {
            if let delta = git_diff_get_delta(pointer, i) {
                deltas.append(Diff.Delta(delta.pointee))
            }
        }
    }
}
