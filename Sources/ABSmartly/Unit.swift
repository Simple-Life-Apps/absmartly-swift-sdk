import Foundation

class Unit: Codable, Equatable {
	public let type: String
	public let uid: String

	init(type: String, uid: String) {
		self.type = type
		self.uid = uid
	}

	static func == (lhs: Unit, rhs: Unit) -> Bool {
		return lhs.type == rhs.type && lhs.uid == rhs.uid
	}
}
