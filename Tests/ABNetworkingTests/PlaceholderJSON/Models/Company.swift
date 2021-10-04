import Foundation

// Represents the company where the users work in UserKit
struct Company: Equatable {
    public let name: String?
    public let catchPhrase: String?
    public let bs: String?
}

extension Company: Codable {}
