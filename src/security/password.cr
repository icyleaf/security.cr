module Security
  class Password
    getter keychain, password
    getter attributes : Hash(String, String)

    def initialize(keychain : String, @password : String? = nil, attributes = {} of String => String)
      @keychain = Security::Keychain.new(keychain)
      @attributes = format_keys_for_attributes(attributes)
    end

    private def format_keys_for_attributes(attributes)
      replace_key_for_attributes(attributes, "acct", "account")
      replace_key_for_attributes(attributes, "srvr", "server")

      attributes
    end

    private def replace_key_for_attributes(attributes, old_key, new_key)
      if value = attributes[old_key]?
        attributes.delete old_key
        attributes[new_key] = value
      end
    end

    module Actions
      CATEGORY = %w(generic internet)

      def add(server : String, account : String, password : String, category = "generic", **options)
        options[:s] = server
        options[:a] = account
        options[:w] = password

        raise Exception.new "Unkown category: #{category}, avaiable in #{CATEGORY.join(", ")}" unless CATEGORY.includes?(category)

        system "security add-#{category}-password #{flags_for_password(options)}"
      end

      def find(**options)
        find options.to_h
      end

      def find(options : Hash(Symbol, String))
        category = extracts_category(options)
        command = "security 2>&1 find-#{category}-password -g #{flags_for_password(options)}"
        password_from_output `#{command}`
      end

      def delete(**options)
        delete options.to_h
      end

      def delete(options : Hash(Symbol, String))
        category = extracts_category(options)
        command = "security 2>&1 delete-#{category}-password -g #{flags_for_password(options)}"
        system "#{command}"
      end

      private def flags_for_password(options : Hash(Symbol, String))
        flags_for_options(options, {
          :account => :a,
          :creator => :c,
          :type    => :C,
          :kind    => :D,
          :value   => :G,
          :comment => :j,
          :server  => :s,
        })
      end

      private def password_from_output(output : String)
        return if output.starts_with?("security:")

        keychain = nil
        password = nil
        attributes = {} of String => String
        output.split(/\n/).each do |line|
          case line
          when .starts_with?("keychain:")
            keychain = line.split(":")[-1].strip.gsub(/^\"|\"$/, "")
          when .starts_with?("password:")
            password = line.split(":")[-1].strip.gsub(/^\"|\"$/, "")
          when .starts_with?("class")
            attributes["category"] = case line.split(":")[-1].strip.gsub(/^\"|\"$/, "")
                                     when "inet"
                                       "internet"
                                     else
                                       "generic"
                                     end
          when /\"(\w{4})\".+\=\"(.+)\"/
            attributes[$1] = $2
          end
        end

        raise Exception.new "Not match keychain with output: #{output}" unless keychain

        Password.new keychain, password, attributes
      end

      private def extracts_category(options)
        if options[:category]?
          options.delete :category
        else
          "generic"
        end
      end

      include Security::Helper
    end

    extend Actions
  end
end
