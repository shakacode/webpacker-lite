if ENV["USE_COVERALLS"] == "TRUE"
  require "coveralls/rake/task"
end

require "pathname"

require_relative "task_helpers"

include WebpackerLite::TaskHelpers

namespace :run_rspec do
  spec_dummy_dir = File.join("spec", "dummy")
  spec_dummy_client_dir = File.join("spec", "dummy", "client")

  desc "Run RSpec for top level only"
  task :gem do
    run_tests_in("", rspec_args: File.join("spec", "webpacker_lite"))
  end

  desc "Runs dummy rspec with turbolinks"
  task dummy: ["dummy_apps:dummy_app"] do
    clean_gen_assets(spec_dummy_dir)
    gen_assets(spec_dummy_client_dir)
    run_tests_in(spec_dummy_dir)
  end

  desc "Runs dummy rspec without turbolinks"
  task dummy_no_turbolinks: ["dummy_apps:dummy_app"] do
    clean_gen_assets(spec_dummy_dir)
    gen_assets(spec_dummy_client_dir)
    run_tests_in(spec_dummy_dir,
                 env_vars: "DISABLE_TURBOLINKS=TRUE",
                 command_name: "dummy_no_turbolinks")
    bundle_install_in(dummy_app_dir)
  end

  desc "Runs dummy respec with turbolinks 2"
  task dummy_turbolinks_2: ["dummy_apps:dummy_app_with_turbolinks_2"] do
    clean_gen_assets(spec_dummy_dir)
    gen_assets(spec_dummy_client_dir)
    run_tests_in(spec_dummy_dir, env_vars:
      "ENABLE_TURBOLINKS_2=TRUE BUNDLE_GEMFILE=#{dummy_app_dir}/Gemfile")
  end

  desc "(HACK) Run RSpec on spec/empty_spec in order to have SimpleCov generate a coverage report from cache"
  task :empty do
    sh %(COVERAGE=true rspec spec/empty_spec.rb)
  end

  if ENV["USE_COVERALLS"] == "TRUE"
    Coveralls::RakeTask.new
  end

  desc "run all tests"
  task run_rspec: [:gem, :dummy, :dummy_no_turbolinks, :dummy_turbolinks_2, :empty] do
    puts "Completed all RSpec tests"
  end
end

msg = <<-DESC
Runs all tests, run `rake -D run_rspec` to see all available test options.
"rake run_rspec:example_basic" is a good way to run only one generator test.
DESC
desc msg
task run_rspec: ["run_rspec:run_rspec"]

private
def calc_path(dir)
  if dir.is_a?(String)
    path = if dir.start_with?(File::SEPARATOR)
      Pathname.new(dir)
    else
      Pathname.new(File.join(gem_root, dir))
    end
  else
    path = dir
  end
  path
end

# Runs rspec in the given directory.
# If string is passed and it's not absolute, it's converted relative to root of the gem.
# TEST_ENV_COMMAND_NAME is used to make SimpleCov.command_name unique in order to
# prevent a name collision. Defaults to the given directory's name.
def run_tests_in(dir, options = {})
  path = calc_path(dir)

  command_name = options.fetch(:command_name, path.basename)
  rspec_args = options.fetch(:rspec_args, "")
  env_vars = %(#{options.fetch(:env_vars, '')} COVERAGE=true TEST_ENV_COMMAND_NAME="#{command_name}")
  sh_in_dir(path.realpath, "#{env_vars} bundle exec rspec #{rspec_args}")
end

def clean_gen_assets(dir)
  path = calc_path(dir)
  sh_in_dir(path.realpath, "yarn run build:clean")
end

def gen_assets(dir)
  path = calc_path(dir)
  sh_in_dir(path.realpath, "yarn run build:test")
end
