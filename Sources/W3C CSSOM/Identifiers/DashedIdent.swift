public struct DashedIdent: Sendable, Hashable {

    public let value: String

    public init(_ value: String) {
        if value.hasPrefix("--") {
            self.value = String(value.dropFirst(2))
        } else {
            self.value = value
        }
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension DashedIdent {

    public static func custom(_ value: String) -> DashedIdent {
        return DashedIdent(value)
    }

    public static func `var`(_ name: DashedIdent) -> String {
        return "var(\(name))"
    }

    public static func `var`(_ name: DashedIdent, fallback: String) -> String {
        return "var(\(name), \(fallback))"
    }
}

extension DashedIdent: ExpressibleByStringLiteral {}

extension DashedIdent: CustomStringConvertible {

    public var description: String {
        return "--\(serializeIdentifier(value))"
    }

    public func `var`() -> String {
        return "var(--\(serializeIdentifier(value)))"
    }

    public func `var`(fallback: String) -> String {
        return "var(--\(serializeIdentifier(value)), \(fallback))"
    }
}
