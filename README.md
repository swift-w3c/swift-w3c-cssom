# swift-w3c-cssom

Use this package when you build CSS text by hand and need identifiers, strings and URLs serialized the way the CSSOM specifies, so that any value is safe to put in a stylesheet. Start from `Ident` for keywords, `CustomIdent` for author-defined names such as animation names, `DashedIdent` for custom properties, `CSSString` for quoted strings and `Url` for `url()` values. For typed CSS properties and values, use swift-w3c-css.

## Laws

- A string is always written in double quotes. A double quote and a backslash are escaped with a backslash. U+0001 to U+001F and U+007F are written as a hexadecimal escape followed by a space, so a newline becomes `\a `. U+0000 becomes U+FFFD. Every other character, including single quotes and non-ASCII text, is written as is.
- `Url` writes its value as such a string inside `url()`. It never uses the unquoted form, and it doesn't percent-encode or otherwise check the URL.
- Identifiers are escaped by the CSSOM rules: a leading digit, or a digit after a leading `-`, is written as a hexadecimal escape, a lone `-` becomes `\-`, and any other ASCII character that is not a letter, digit, `-` or `_` gets a backslash before it. Non-ASCII characters are written as is.
- Identifiers and strings keep their case and compare by their exact value.
- `DashedIdent` drops one leading `--` from its value and always writes it back, so a name given with or without `--` is the same value. A single leading `-` is part of the name, so it is written with three dashes.
- The fallback passed to `DashedIdent.var(fallback:)` is written as given, without escaping.
