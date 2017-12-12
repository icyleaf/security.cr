module Security
  class Certificate
    module Actions
      def find_certificate(**options)
        find_certificate(options.to_h)
      end

      def find_certificate(options : Hash(Symbol, String))
        `security find-certificate -a #{flags_for_cerificate(options)}`
      end

      def find_identity(**options)
        find_identity(options.to_h)
      end

      def find_identity(options : Hash(Symbol, String))
        `security find-identity #{flags_for_cerificate(options)}`
      end

      private def flags_for_cerificate(options : Hash(Symbol, String))
        keychain = if path = options[:keychain]?
                     options.delete :keychain
                   end
        flags = flags_for_options(options, {
          :name   => :c,
          :email  => :e,
          :policy => :p,
          :hash   => :Z,
        })

        keychain ? "#{flags} #{keychain}" : flags
      end

      include Security::Helper
    end

    extend Actions
  end
end
