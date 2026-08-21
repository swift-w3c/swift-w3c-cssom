public struct CSSString: Sendable, Hashable {

    public let value: String

    public init(_ value: String) {
        self.value = value
    }

}

extension CSSString {

    public static let empty = CSSString("")
}

extension CSSString: CustomStringConvertible {

    public var description: String {
        return serializeString(value)
    }
}

extension CSSString: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension CSSString: ExpressibleByStringInterpolation {

}
