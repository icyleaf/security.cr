require "./security/ext/*"
require "./security/*"

module Security

  {% for category in %w(genric internet) %}
    def self.add_{{ category.id }}_password(server : String, account : String, password : String, **options)
      Security::Password.add category: {{category.id.stringify}}, server: server, account: account, password: password, options: options.to_h
    end

    def self.find_{{ category.id }}_password(**options)
      options[:category] = {{ category.id.stringify }}
      Security::Password.find options
    end

    def self.delete_{{ category.id }}_password(**options)
      options[:category] = {{ category.id.stringify }}
      Security::Password.delete options
    end
  {% end %}

  def self.list_keychains(domain = "user")
    Security::Keychain.list domain
  end

  def self.defalut_keychain
    Security::Keychain.default
  end

  def self.login_keychain
    Security::Keychain.login
  end

  def self.lock_keychain
    Security::Keychain.lock
  end

  def self.unlock_keychain(password : String)
    Security::Keychain.unlock password
  end

  def self.create_keychain(path : String, password : String)
    Security::Keychain.create path, password
  end

  def self.delete_keychain(path : String)
    Security::Keychain.delete path
  end
end
