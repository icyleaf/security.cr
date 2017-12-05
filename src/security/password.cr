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

      def add(server : String, account : String, password : String, category = "generic", options = {} of Symbol => String)
        options[:s] = server
        options[:a] = account
        options[:w] = password

        raise Exception.new "Unkown category: #{category}, avaiable in #{CATEGORY.join(", ")}" unless CATEGORY.includes?(category)

        system "security add-#{category}-password #{flags_for_options(options)}"
      end

      def find(**options)
        find(options.to_h)
      end

      def find(options : Hash(Symbol, String))
        category = if options[:category]?
                     options.delete :category
                   else
                     "generic"
                   end

        command = "security 2>&1 find-#{category}-password -g #{flags_for_options(options)}"
        pp command
        password_from_output `#{command}`
      end

      def delete(**options)
      end

      private def flags_for_options(options : Hash(Symbol, String))
        flags = options.dup
        flag_key_for_options(flags, :account, :a)
        flag_key_for_options(flags, :creator, :c)
        flag_key_for_options(flags, :type, :C)
        flag_key_for_options(flags, :kind, :D)
        flag_key_for_options(flags, :value, :G)
        flag_key_for_options(flags, :comment, :j)
        flag_key_for_options(flags, :server, :s)

        flags.delete_if { |k, v| v.nil? }.map { |k, v| "-#{k} #{v.shellescape}".strip }.join(" ")
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

      private def flag_key_for_options(options, long, short)
        if value = options[long]?
          options.delete long
          options[short] ||= value
        end
      end
    end

    extend Actions
  end
end
