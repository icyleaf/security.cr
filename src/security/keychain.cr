module Security
  class Keychain
    getter path

    def initialize(@path : String)
    end

    # Unlock specified keychain
    def unlock(password)
      system "security unlock-keychain -p #{password.shellescape} #{path.shellescape}"
    end

    # Lock specified keychain
    def lock
      system "security lock-keychain #{path.shellescape}"
    end

    # Set default keychain for specified keychain
    def default!
      system "security default-keychain #{path.shellescape}"
    end

    # Change password for specified keychain
    def change_password(old_password : String, new_password : String)
      system "security set-keychain-password -o #{old_password} -p #{new_password} #{path.shellescape}"
    end

    # Set settings for specified keychain
    def info(timeout : Int32? = nil, lock_on_sleep = false, lock_after_timeout = false)
      system String.build do |io|
        io << "security set-keychain-settings"
        io << " -l" if lock_on_sleep
        io << " -u" if lock_after_timeout
        io << " -t #{timeout}" if timeout
        io << " #{path.shellescape}"
      end.to_s
    end

    # Show information
    def info
      output = IO::Memory.new
      error = IO::Memory.new
      command = "security show-keychain-info #{path.shellescape}"
      # NOTE: I don't know why get output use error, it issued both in ruby and crystal.
      status = Process.run command, shell: true, output: error, error: output

      raise Exception.new error.to_s unless status.success?

      output.to_s.split(" ")[2..-1].map { |line| line.strip }
    end

    # Delete keychain
    def delete
      system "security delete-keychain #{path.shellescape}"
    end

    module Actions
      DOMAINS = %w(user system common dynamic)

      # Create keychain
      def create(path : String, password : String)
        path += ".keychain" unless path.ends_with?(".keychain")
        system "security create-keychain -p #{password.shellescape} #{path.shellescape}"
      end

      def delete(path : String)
        Security::Keychain.new(path).delete
      end

      def list(domain = "user")
        escape_output `security list-keychains -d #{domain}`
      end

      def default
        escape_output(`security default-keychain`).first
      end

      def login
        escape_output(`security login-keychain`).first
      end

      def lock
        system "security lock-keychain"
      end

      def unlock(password : String)
        system "security unlock-keychain -p #{password.shellescape}"
      end

      private def escape_output(output)
        output.split(/\n/).select { |l| !l.empty? }.map { |l| Security::Keychain.new l.strip.gsub(/^\"|\"$/, "") }
      end
    end

    extend Actions
  end
end
