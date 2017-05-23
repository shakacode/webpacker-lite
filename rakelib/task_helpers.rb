module WebpackerLite
  module TaskHelpers
    # Returns the root folder of the webpacker_lite gem
    def gem_root
      File.expand_path("../../.", __FILE__)
    end

    def dummy_app_dir
      File.join(gem_root, "spec/dummy")
    end

    # Executes a string or an array of strings in a shell in the given directory
    def sh_in_dir(dir, shell_commands)
      shell_commands = [shell_commands] if shell_commands.is_a?(String)
      shell_commands.each { |shell_command| sh %(cd #{dir} && #{shell_command.strip}) }
    end

    def bundle_install_in(dir)
      sh_in_dir(dir, "bundle install")
    end

    def bundle_install_in_no_turbolinks(dir)
      sh_in_dir(dir, "DISABLE_TURBOLINKS=TRUE bundle install")
    end

    def bundle_install_with_turbolinks_2_in(dir)
      sh_in_dir(dir, "ENABLE_TURBOLINKS_2=TRUE BUNDLE_GEMFILE=#{dir}/Gemfile bundle install")
    end

    # Runs bundle exec using that directory's Gemfile
    def bundle_exec(dir: nil, args: nil, env_vars: "")
      sh_in_dir(dir, "#{env_vars} #{args}")
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), new_hash|
        new_key = key.is_a?(String) ? key.to_sym : key
        new_value = value.is_a?(Hash) ? symbolize_keys(value) : value
        new_hash[new_key] = new_value
      end
    end
  end
end
