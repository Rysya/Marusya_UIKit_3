import Foundation

enum StatusError: Error {
    case emptyStatus
}

final class StatusService {
    
    func isValidStatus(status: String) throws {
        guard !status.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw StatusError.emptyStatus
        }
    }
}
