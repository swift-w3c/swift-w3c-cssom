public struct CustomIdent: Sendable, Hashable {

    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension CustomIdent {

    public static func custom(_ value: String) -> CustomIdent {

        return CustomIdent(value)
    }
}

extension CustomIdent: ExpressibleByStringLiteral {}

extension CustomIdent: CustomStringConvertible {

    public var description: String {
        return serializeIdentifier(value)
    }
}
