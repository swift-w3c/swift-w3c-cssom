// String Tests.swift
// swift-w3c-cssom
//
// Tests for CSSOM CSSString type

import Testing

@testable import W3C_CSSOM

@Suite
struct `CSSString Tests` {
    // MARK: - Unit

    @Suite
    struct Unit {
        // Per CSSOM spec: strings are always serialized with double quotes
        @Test(arguments: [
            ("Hello, world!", "\"Hello, world!\""),
            ("Content", "\"Content\""),
            ("", "\"\""),
        ])
        func `string renders correctly`(text: String, expected: String) {
            let str = CSSString(text)
            #expect(str.description == expected)
        }

        // Per CSSOM: double quotes are escaped as \"
        @Test func `double quotes are escaped`() {
            let str = CSSString("Say \"Hello\"")
            #expect(str.description == "\"Say \\\"Hello\\\"\"")
        }

        @Test func `multiple double quotes are escaped`() {
            let str = CSSString("\"Quote\" and \"another\"")
            #expect(str.description == "\"\\\"Quote\\\" and \\\"another\\\"\"")
        }

        // Per CSSOM: single quotes don't need escaping in double-quoted strings
        @Test func `single quotes remain literal`() {
            let str = CSSString("It's great!")
            #expect(str.description == "\"It's great!\"")
        }

        @Test func `multiple single quotes remain literal`() {
            let str = CSSString("'Quote' and 'another'")
            #expect(str.description == "\"'Quote' and 'another'\"")
        }

        // Per CSSOM: backslashes are escaped as \\
        @Test func `backslashes are escaped`() {
            let str = CSSString("C:\\Users\\file.txt")
            #expect(str.description == "\"C:\\\\Users\\\\file.txt\"")
        }

        // Per CSSOM: control characters (U+0001-U+001F, U+007F) are escaped as \<hex><space>

        @Test func `newline is escaped as code point`() {
            // U+000A (newline) -> \a
            let str = CSSString("Line 1\nLine 2")
            #expect(str.description == "\"Line 1\\a Line 2\"")
        }

        @Test func `multiple newlines are escaped`() {
            let str = CSSString("A\nB\nC")
            #expect(str.description == "\"A\\a B\\a C\"")
        }

        @Test func `tab is escaped as code point`() {
            // U+0009 (tab) -> \9
            let str = CSSString("Before\tAfter")
            #expect(str.description == "\"Before\\9 After\"")
        }

        @Test func `control character u0001 is escaped`() {
            let str = CSSString("Test\u{0001}ing")
            #expect(str.description == "\"Test\\1 ing\"")
        }

        @Test func `control character u001f is escaped`() {
            let str = CSSString("Test\u{001F}ing")
            #expect(str.description == "\"Test\\1f ing\"")
        }

        @Test func `control character u007f is escaped`() {
            let str = CSSString("Test\u{007F}ing")
            #expect(str.description == "\"Test\\7f ing\"")
        }

        @Test func `null character is replaced with replacement character`() {
            // U+0000 -> U+FFFD
            let str = CSSString("Before\u{0000}After")
            #expect(str.description == "\"Before\u{FFFD}After\"")
        }

        @Test func `spaces are preserved`() {
            let str = CSSString("Hello World")
            #expect(str.description == "\"Hello World\"")
        }

        @Test func `unicode characters are preserved`() {
            let str = CSSString("Hello 世界 🌍")
            #expect(str.description == "\"Hello 世界 🌍\"")
        }

        @Test func `emoji are preserved`() {
            let str = CSSString("😀😃😄")
            #expect(str.description == "\"😀😃😄\"")
        }

        @Test func `parentheses are preserved`() {
            let str = CSSString("(Hello)")
            #expect(str.description == "\"(Hello)\"")
        }

        @Test func `commas are preserved`() {
            let str = CSSString("Hello, World")
            #expect(str.description == "\"Hello, World\"")
        }

        @Test func `string literal creates css string`() {
            let str: CSSString = "my-string"
            #expect(str.description == "\"my-string\"")
        }

        @Test func `equal strings are equal`() {
            let str1 = CSSString("test")
            let str2 = CSSString("test")
            #expect(str1 == str2)
        }

        @Test func `different strings are not equal`() {
            let str1 = CSSString("test1")
            let str2 = CSSString("test2")
            #expect(str1 != str2)
        }

        @Test func `strings can be used in sets`() {
            let set: Set<CSSString> = [
                CSSString("a"),
                CSSString("b"),
                CSSString("a"),  // duplicate
            ]
            #expect(set.count == 2)
        }
    }

    // MARK: - Edge Case

    @Suite
    struct `Edge Case` {
        @Test func `empty string`() {
            let str = CSSString("")
            #expect(str.description == "\"\"")
        }

        @Test func `whitespace only`() {
            let str = CSSString("   ")
            #expect(str.description == "\"   \"")
        }

        @Test func `very long string`() {
            let longText = String(repeating: "A", count: 1000)
            let str = CSSString(longText)
            #expect(str.description.hasPrefix("\""))
            #expect(str.description.hasSuffix("\""))
            #expect(str.description.count == 1002)  // 1000 chars + 2 quotes
        }

        @Test func `string with all escape characters`() {
            let str = CSSString("Quote:\"\nBackslash:\\\nControl:\u{0001}")
            #expect(str.description.contains("\\\""))
            #expect(str.description.contains("\\\\"))
            #expect(str.description.contains("\\a "))
            #expect(str.description.contains("\\1 "))
        }
    }

    // MARK: - Integration

    @Suite
    struct Integration {
        @Test func `string in content property`() {
            let str = CSSString("Hello")
            let property = "content: \(str)"
            #expect(property == "content: \"Hello\"")
        }

        @Test func `string in font-family property`() {
            let str = CSSString("Arial, sans-serif")
            let property = "font-family: \(str)"
            #expect(property == "font-family: \"Arial, sans-serif\"")
        }

        @Test func `string in quotes property`() {
            let open = CSSString("\u{201C}")  // left double quotation mark
            let close = CSSString("\u{201D}")  // right double quotation mark
            let property = "quotes: \(open) \(close)"
            #expect(property == "quotes: \"\u{201C}\" \"\u{201D}\"")
        }

        @Test func `follows cssom string serialization rules`() {
            // Per CSSOM: strings always use double quotes
            let str = CSSString("test")
            #expect(str.description.hasPrefix("\""))
            #expect(str.description.hasSuffix("\""))
        }

        @Test func `properly escapes required characters`() {
            // Per CSSOM: NULL, control chars, double quotes, and backslashes must be escaped
            let str = CSSString("Test\"\\\u{0001}")
            let desc = str.description
            #expect(desc.contains("\\\""))  // escaped double quote
            #expect(desc.contains("\\\\"))  // escaped backslash
            #expect(desc.contains("\\1 "))  // escaped control char
        }
    }
}

// MARK: - Performance

extension `Performance Tests` {
    @Suite
    struct `CSSString - Performance` {
        @Test(.timeLimit(.minutes(1)))
        func `string creation 100K times`() {
            (0..<100_000).forEach { i in
                _ = CSSString("string\(i % 100)")
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `string description generation 100K times`() {
            let str = CSSString("test string")
            for _ in 0..<100_000 {
                _ = str.description
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `string with escaping 100K times`() {
            let str = CSSString("Test\"\\\n")
            for _ in 0..<100_000 {
                _ = str.description
            }
        }
    }
}
