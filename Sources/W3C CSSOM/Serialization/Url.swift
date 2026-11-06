public struct Url: Sendable, Hashable {

    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

extension Url {

    public static func dataUrl(
        // swift-linter:disable:next raw concept
        // REASON: RFC_9110.MediaType owns this, but W3C CSSOM has no dependencies and swift-rfc-9110 would bring over a hundred packages into it and into all of CSS.
        mimeType: String,
        base64Data: String
    ) -> Url {
        let dataUrl = "data:\(mimeType);base64,\(base64Data)"
        return Url(dataUrl)
    }
}

extension Url: CustomStringConvertible {

    public var description: String {
        return "url(\(serializeString(value)))"
    }
}

extension Url: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(value)
    }
}
