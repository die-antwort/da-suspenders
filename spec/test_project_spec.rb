describe "the test project" do
  
  def create_application_spec_file
    File.open("spec/acceptance/application_spec.rb", "w") do |file|
      file.write %q{
        require "acceptance/acceptance_helper"

        feature "The application works correctly" do
          scenario "jQuery and Modernizr work correctly", :js => true do
            visit "/users"
            page.evaluate_script("$('html').hasClass('js')").should be_true
            page.evaluate_script("$('html').hasClass('no-js')").should be_false
          end
  
          scenario "Stylesheets are generated correctly" do
            FileUtils.rm_rf ["#{Rails.root}/tmp/cache/assets", "#{Rails.root}/tmp/cache/sass"]
            visit "/assets/application.css"
            page.should have_content "/bootstrap-sass-2."
          end
        end
      }.gsub(/^        /, "")
    end
  end

  before(:all) do
    # Make sure to have a non-bundled ENV, even when running via "bundle exec cucumber ..."
    ENV["RUBYOPT"] = nil
    ENV["BUNDLE_GEMFILE"] = nil

    Dir.chdir('test_project') do
      system "rails g scaffold user username:string"
      system "bundle exec rake db:drop db:create db:migrate" 
      create_application_spec_file
    end
  end
  
  it "works correctly" do
    Dir.chdir("test_project") do
      system "bundle exec rake spec"
      $?.should be_success
    end
  end
end