describe "the test project" do
  
  def use_delocalize_in_user_model
    lines = File.readlines("app/models/user.rb")
    lines.insert(2, "  include Delocalize::Delocalizable\n") unless lines.first =~ /ActiveRecord::Base/
    lines.insert(-2, "  delocalize :weight => :number\n")
    File.write("app/models/user.rb", lines.join)
  end
      
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
  
          scenario "Delocalization works correctly" do
            visit "/users/new"
            fill_in "Weight", :with => "67,89"
            click_on "User erstellen"
            (@user = User.last).weight.should == 67.89
    
            @user.update_attributes!(:weight => 1234.56)
            visit "/users/#{@user.to_param}/edit"
            page.should have_field "Weight", :with => "1.234,56"
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
      system "rails g scaffold user username:string weight:float" # FIXME: Should use decimal, but this currently fails with mongoid ...
      system "bundle exec rake db:drop db:create db:migrate"
      use_delocalize_in_user_model
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