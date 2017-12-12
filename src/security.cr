module Security
  def self.list_keychains(domain = "user")
    Security::Keychain.list domain
  end

  def self.default_keychain
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

  {% for category in %w(genric internet) %}
  def self.add_{{ category.id }}_password(server : String, account : String, password : String, **options)
    Security::Password.add category: {{category.id.stringify}}, server: server, account: account, password: password, options: options
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

  module Helper
    private def flags_for_options(options : Hash(Symbol, String), replaces : Hash(Symbol, Symbol)? = nil)
      flags = options.dup
      if replaces
        replaces.each do |old_key, new_key|
          flag_key_for_options(flags, old_key, new_key)
        end
      end

      flags.delete_if { |k, v| v.nil? }.map { |k, v| "-#{k} #{v.shellescape}".strip }.join(" ")
    end

    private def flag_key_for_options(options : Hash(Symbol, String), old_key : Symbol, new_key : Symbol)
      if value = options[old_key]?
        options.delete old_key
        options[new_key] ||= value
      end
    end
  end
end

require "./security/**"
