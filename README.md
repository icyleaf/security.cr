# security.cr

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
[![Tag](https://img.shields.io/github/tag/icyleaf/security.cr.svg)](https://github.com/icyleaf/pngdefry.cr/blob/master/CHANGELOG.md)

macOS security command-line tool wrapper written by Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  security:
    github: icyleaf/security.cr
```

## Usage

```crystal
require "security"

# Get default keychain
Security.default_keychain
# => #<Security::Keychain:0x109288d00 @path="/Users/icyleaf/Library/Keychains/login.keychain-db">

# List keychains
Security.list_keychains
# => [#<Security::Keychain:0x102b7fb20 @path="/Users/icyleaf/Library/Keychains/login.keychain-db">]

# Unlock keychain
Security.unlock_keychain Security.default_keychain.path
# => true

# Add internet password
Security.add_internet_password(server: "test.example.com", account: "foo", password: "bar")

# Find certificate
Security::Certificate.find_certificate name: "github.com", keychain: Security.default_keychain.path
```

## How to Contribute

Your contributions are always welcome! Please submit a pull request or create an issue to add a new question, bug or feature to the list.

All [Contributors](https://github.com/icyleaf/pngdefry.cr/graphs/contributors) are on the wall.

## You may also like

- [pngdefry.cr](https://github.com/icyleaf/pngdefry.cr) - Pngdefry.cr is a wrapper for pngdefry written by Crystal.

## License

[MIT License](https://github.com/icyleaf/security.cr/blob/master/LICENSE) © icyleaf
