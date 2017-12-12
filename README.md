# security.cr

![Language](https://img.shields.io/badge/language-crystal-black.svg)
[![Tag](https://img.shields.io/github/tag/icyleaf/security.cr.svg)](https://github.com/icyleaf/security.cr/blob/master/CHANGELOG.md)
[![Dependency Status](https://shards.rocks/badge/github/icyleaf/security.cr/status.svg)](https://shards.rocks/github/icyleaf/security.cr)
[![devDependency Status](https://shards.rocks/badge/github/icyleaf/security.cr/dev_status.svg)](https://shards.rocks/github/icyleaf/security.cr)
[![License](https://img.shields.io/github/license/icyleaf/security.cr.svg)](https://github.com/icyleaf/security.cr/blob/master/LICENSE)

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

```

## Contributing

1. Fork it ( https://github.com/icyleaf/security.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) - creator, maintainer
