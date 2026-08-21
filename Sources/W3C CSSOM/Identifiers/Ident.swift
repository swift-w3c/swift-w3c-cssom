public struct Ident: Sendable, Hashable {

    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

extension Ident: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.value = value
    }
}

extension Ident: CustomStringConvertible {

    public var description: String {
        return serializeIdentifier(value)
    }
}
