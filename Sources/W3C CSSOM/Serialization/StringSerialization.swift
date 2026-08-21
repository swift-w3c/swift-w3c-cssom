func serializeString(_ string: String) -> String {
    var result = "\""

    for char in string {
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

        if value == 0x0022 {
            result.append("\\\"")
            continue
        }

        if value == 0x005C {
            result.append("\\\\")
            continue
        }

        result.append(char)
    }

    result.append("\"")
    return result
}

private func escapeAsCodePoint(_ scalar: Unicode.Scalar) -> String {
    return "\\\(String(scalar.value, radix: 16)) "
}
