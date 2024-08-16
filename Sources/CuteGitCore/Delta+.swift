import SwiftGit2

extension Diff.Delta: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(oldFile?.path)
        hasher.combine(newFile?.path)
        hasher.combine(status.rawValue)
    }
    
    public static func == (lhs: Diff.Delta, rhs: Diff.Delta) -> Bool {
        return lhs.oldFile?.path == rhs.oldFile?.path &&
               lhs.newFile?.path == rhs.newFile?.path &&
               lhs.status == rhs.status
    }
}

extension Diff.Status {

    public var symbol: String {
        switch self {
        case .conflicted:
            return "C"
        case .modified:
            return "M"
        case .added:
            return "A"
        case .deleted:
            return "D"
        case .untracked:
            return "U"
        default:
            return " "
        }
        
    }
    
    
    public var sfSymbolName: String {
        switch self {
        case .conflicted:
            return "exclamationmark.triangle"
        case .modified:
            return "pencil"
        case .added:
            return "plus"
        case .deleted:
            return "minus"
        default:
            return "questionmark"
        }
        
    }
}

extension Diff.Status: CaseIterable {
    public static var allCases: [Diff.Status] {
        [
            .conflicted, .added, .deleted, .modified, .untracked
        ]
    }

    var allIncludedCases: [Diff.Status] {
        return Diff.Status.allCases.compactMap {
            if self.contains($0) { return $0 }
            return nil
        }
    }
}
