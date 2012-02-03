require "fileutils"
require "pathname"
require "trout"

template_root = File.expand_path(File.join(File.dirname(__FILE__)))
source_paths << File.join(template_root, "files")

# Helpers

def action_mailer_host(rails_env, host)
  inject_into_file(
    "config/environments/#{rails_env}.rb",
    "\n\n  config.action_mailer.default_url_options = { :host => '#{host}' }",
    :before => "\nend"
  )
end

def origin
  ENV["REPO"].presence || "git://github.com/die-antwort/da-suspenders.git"
end

def trout(destination_path)
  parent = Pathname.new(destination_path).parent
  FileUtils.mkdir_p(parent) unless File.exists?(parent) 
  run "trout checkout --source-root=template/trout #{destination_path} #{origin}"
end

# Actions

def create_gemfile_and_install_gems
  say "Creating Gemfile and installing gems (this may take a while)", :yellow
  trout "Gemfile"
  run "bundle install"
end
  
def add_staging_environment
  say "Adding staging environment", :yellow
  run "cp config/environments/production.rb config/environments/staging.rb"
end

def setup_action_mailer
  say "Setting up action mailer config", :yellow
  action_mailer_host "development", "localhost:3000"
  action_mailer_host "test",        "example.com"
  action_mailer_host "staging",     "#{app_name}.dev.die-antwort.eu"
  action_mailer_host "production",  "FIXME"
end

def setup_database
  say "Setting up database config", :yellow
  template "mysql_database.yml.erb", "config/database.yml", :force => true
  rake "db:create"
end

def setup_german_locale
  say "Setting up german locale", :yellow
  trout "config/locales/de.yml"
  gsub_file 'config/application.rb', '# config.i18n.default_locale = :de', 'config.i18n.default_locale = :de'
end

def setup_viennese_timezone
  say "Setting up viennese timezone", :yellow
  gsub_file 'config/application.rb', "# config.time_zone = 'Central Time (US & Canada)'", "config.time_zone = 'Vienna'"
end

def disable_timestamped_migrations
  say "Disabling timestamped migrations", :yellow
  inject_into_class "config/application.rb", "Application", "\n    config.active_record.timestamped_migrations = false\n\n"
end
  
def update_generators_config
  say "Updating config for generators", :yellow
  generators_config = <<-RUBY
    config.generators do |generate|
      generate.stylesheets false
      generate.test_framework :rspec
    end
  RUBY
  inject_into_class "config/application.rb", "Application", generators_config
end

def create_application_layout_and_views
  say "Creating application layout and shared views", :yellow
  trout "app/views/layouts/application.html.erb"
  trout "app/views/shared/_flashes.html.erb"
end

def install_misc_support_files
  say "Installing miscellaneous support files", :yellow
  trout "config/initializers/errors.rb"
  trout "app/helpers/body_class_helper.rb"
end

def install_app_config
  say "Installing app_config", :yellow
  generate "app_config:install staging"
end

def install_compass
  say "Installing compass", :yellow
  remove_file "app/assets/stylesheets/application.css"
  trout "app/assets/stylesheets/application.css.scss"
end

def install_formtastic
  say "Installing formtastic", :yellow
  generate "formtastic:install"
end

def install_javascripts
  say "Installing application.js.coffee and modernizr", :yellow
  remove_file "app/assets/javascripts/application.js"
  trout "app/assets/javascripts/application.js.coffee"
  trout "vendor/assets/javascripts/modernizr.js" 
end

def install_rspec_and_cucumber
  say "Installing rspec and cucumber", :yellow
  generate "rspec:install"
  generate "cucumber:install", "--rspec --capybara"
  inject_into_file "features/support/env.rb",
                   %{Capybara.save_and_open_page_path = "tmp"\n} +
                   %{Capybara.javascript_driver = :webkit\n},
                   :before => %{Capybara.default_selector = :css}
  inject_into_file "features/support/paths.rb",
                   %{    when %r{"(/.*)?"}\n} +
                   %{      $1\n\n},
                   :before => "    else"
  copy_file "factory_girl_steps.rb", "features/step_definitions/factory_girl_steps.rb"
  trout "features/step_definitions/js_steps.rb"
end

def cleanup
  say "Cleaning up", :yellow
  remove_file 'README'
  remove_file 'public/index.html'
  remove_file 'public/images/rails.png'
end

create_gemfile_and_install_gems
add_staging_environment
setup_database
setup_german_locale
setup_viennese_timezone
disable_timestamped_migrations
update_generators_config
create_application_layout_and_views
install_misc_support_files
install_app_config
install_compass
install_formtastic
install_javascripts
install_rspec_and_cucumber
cleanup

say "Rails app #{app_name} has been created successully!", :blue
say "Remember to run 'rails generate hoptoad' with your API key.", :blue