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
  "git://github.com/die-antwort/da-suspenders.git"
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
  run "compass init rails . --sass-dir app/stylesheets --css-dir public/stylesheets -q"
  inside 'app/stylesheets' do
    remove_file 'ie.scss'
    remove_file 'print.scss'
    remove_file 'screen.scss'
    empty_directory 'content'
    empty_directory 'vendor'
  end
  trout "app/stylesheets/application.scss" 
  trout "app/stylesheets/ie.scss" 
end

def install_formtastic
  say "Installing formtastic", :yellow
  generate "formtastic:install"
  remove_file "public/stylesheets/formtastic.css"
  remove_file "public/stylesheets/formtastic-changes.css"
  trout "lib/templates/erb/scaffold/_form.html.erb"
end

def install_sprockets_and_jquery
  say "Installing sprockets, jQuery, and some other javascripts", :yellow
  plugin 'sprockets-rails', :git => 'git://github.com/gmoeck/sprockets-rails.git'
  plugin 'jrails', :git => 'git://github.com/die-antwort/jrails.git'
  route 'SprocketsApplication.routes(self)'
  remove_dir 'public/javascripts'
  remove_file "app/javascripts/application.js"
  trout "app/javascripts/application.js"
  trout "vendor/sprockets/modernizr/src/modernizr.js" 
  trout "vendor/sprockets/jquery-ujs/src/rails.js" 
end

def install_rspec_and_cucumber
  say "Installing rspec and cucumber", :yellow
  generate "rspec:install"
  generate "cucumber:install", "--rspec --capybara"
  inject_into_file "features/support/env.rb",
                   %{Capybara.save_and_open_page_path = "tmp"\n} +
                   %{Capybara.javascript_driver = :akephalos\n},
                   :before => %{Capybara.default_selector = :css}
#  replace_in_file "features/support/env.rb",
#                  %r{require .*capybara_javascript_emulation.*},
#                  ''
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
update_generators_config
create_application_layout_and_views
install_misc_support_files
install_app_config
install_compass
install_formtastic
install_sprockets_and_jquery
install_rspec_and_cucumber
cleanup

say "Rails app #{app_name} has been created successully!", :blue
say "Remember to run 'rails generate hoptoad' with your API key.", :blue