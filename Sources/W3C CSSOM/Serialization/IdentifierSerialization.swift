func serializeIdentifier(_ identifier: String) -> String {
    guard !identifier.isEmpty else {
        return ""
    }

    var result = ""
    let characters = Array(identifier)

    for (index, char) in characters.enumerated() {
        let scalar = char.unicodeScalars.first!
        let value = scalar.value

        if value == 0x0000 {
            result.append("\u{FFFD}")
            continue
        }

        if (value >= 0x0001 && value <= 0x001F) || value == 0x007F {
            result.append(escapeAsCodePoint(scalar))
            continue
        }

        if index == 0 && value >= 0x0030 && value <= 0x0039 {
            result.append(escapeAsCodePoint(scalar))
            continue
        }

        if index == 1 && characters[0] == "-" && value >= 0x0030 && value <= 0x0039 {
            result.append(escapeAsCodePoint(scalar))
            continue
        }

        if index == 0 && characters.count == 1 && char == "-" {
            result.append("\\-")
            continue
        }

        if isValidIdentifierCharacter(scalar) {
            result.append(char)
            continue
        }

        result.append("\\")
        result.append(char)
    }

    return result
}

private func isValidIdentifierCharacter(_ scalar: Unicode.Scalar) -> Bool {
    let value = scalar.value

    return (value >= 0x0041 && value <= 0x005A)
        || (value >= 0x0061 && value <= 0x007A)
        || (value >= 0x0030 && value <= 0x0039)
        || value == 0x002D
        || value == 0x005F
        || value >= 0x0080
}

private func escapeAsCodePoint(_ scalar: Unicode.Scalar) -> String {
    return "\\\(String(scalar.value, radix: 16)) "
}
