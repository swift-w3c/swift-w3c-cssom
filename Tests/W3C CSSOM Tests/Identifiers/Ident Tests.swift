import Testing

@testable import W3C_CSSOM

@Suite
struct `Ident Tests` {

    @Suite
    struct Unit {
        @Test(arguments: [
            ("test", "test"),
            ("my-ident", "my-ident"),
            ("_private", "_private"),
            ("value123", "value123"),
        ])
        func `ident renders correctly`(value: String, expected: String) {
            let ident = Ident(value)
            #expect(ident.description == expected)
        }

        @Test func `string literal creates ident`() {
            let ident: Ident = "my-ident"
            #expect(ident.description == "my-ident")
        }

        @Test func `equal idents are equal`() {
            let ident1 = Ident("test")
            let ident2 = Ident("test")
            #expect(ident1 == ident2)
        }

        @Test func `different idents are not equal`() {
            let ident1 = Ident("test1")
            let ident2 = Ident("test2")
            #expect(ident1 != ident2)
        }

        @Test func `idents can be used in sets`() {
            let set: Set<Ident> = [
                Ident("a"),
                Ident("b"),
                Ident("a"),
            ]
            #expect(set.count == 2)
        }

        @Test func `idents can be used as dictionary keys`() {
            let dict: [Ident: String] = [
                Ident("display"): "block",
                Ident("position"): "absolute",
            ]
            #expect(dict[Ident("display")] == "block")
        }

        @Test func `value property returns raw value`() {
            let ident = Ident("my-ident")
            #expect(ident.value == "my-ident")
        }
    }

    @Suite
    struct `Edge Case` {
        @Test func `single character ident`() {
            let ident = Ident("a")
            #expect(ident.description == "a")
        }

        @Test func `ident with numbers`() {
            let ident = Ident("test123")
            #expect(ident.description == "test123")
        }

        @Test func `ident with hyphens`() {
            let ident = Ident("my-ident-value")
            #expect(ident.description == "my-ident-value")
        }

        @Test func `ident with underscores`() {
            let ident = Ident("my_ident_value")
            #expect(ident.description == "my_ident_value")
        }

        @Test func `case sensitive`() {
            let lower = Ident("test")
            let upper = Ident("TEST")
            #expect(lower.description != upper.description)
            #expect(lower != upper)
        }
    }

    @Suite
    struct Integration {
        @Test func `ident in property value`() {
            let value = "display: \(Ident("block"))"
            #expect(value == "display: block")
        }

        @Test func `ident in keyword value`() {
            let value = "position: \(Ident("absolute"))"
            #expect(value == "position: absolute")
        }

        @Test func `ident as enum value`() {
            let value = "text-align: \(Ident("center"))"
            #expect(value == "text-align: center")
        }

        @Test func `display values`() {
            #expect(Ident("block").description == "block")
            #expect(Ident("inline").description == "inline")
            #expect(Ident("flex").description == "flex")
            #expect(Ident("grid").description == "grid")
            #expect(Ident("none").description == "none")
        }

        @Test func `position values`() {
            #expect(Ident("static").description == "static")
            #expect(Ident("relative").description == "relative")
            #expect(Ident("absolute").description == "absolute")
            #expect(Ident("fixed").description == "fixed")
            #expect(Ident("sticky").description == "sticky")
        }

        @Test func `text-align values`() {
            #expect(Ident("left").description == "left")
            #expect(Ident("right").description == "right")
            #expect(Ident("center").description == "center")
            #expect(Ident("justify").description == "justify")
        }

        @Test func `overflow values`() {
            #expect(Ident("visible").description == "visible")
            #expect(Ident("hidden").description == "hidden")
            #expect(Ident("scroll").description == "scroll")
            #expect(Ident("auto").description == "auto")
        }

        @Test func `follows identifier syntax`() {

            let ident = Ident("myIdent")
            #expect(ident.description == "myIdent")
        }

        @Test func `preserves case`() {

            let lower = Ident("value")
            let upper = Ident("VALUE")
            let mixed = Ident("Value")

            #expect(lower.description == "value")
            #expect(upper.description == "VALUE")
            #expect(mixed.description == "Value")
        }
    }
}

extension `Performance Tests` {
    @Suite
    struct `Ident - Performance` {
        @Test(.timeLimit(.minutes(1)))
        func `ident creation 100K times`() {
            (0..<100_000).forEach { i in
                _ = Ident("ident\(i % 100)")
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `ident description 100K times`() {
            let ident = Ident("block")
            for _ in 0..<100_000 {
                _ = ident.description
            }
        }

        @Test(.timeLimit(.minutes(1)))
        func `ident comparison 100K times`() {
            let ident1 = Ident("test")
            let ident2 = Ident("test")
            for _ in 0..<100_000 {
                _ = ident1 == ident2
            }
        }
    }
}
