Feature: Running integration tests in the generated project
  
  Background:
    Given I have a clean environment 
    
  Scenario: The generated project works correctly
    Given I drop and create the required databases
    And I generate "scaffold user username:string"
    And I run the rake task "db:migrate"
    And I create a file named "spec/acceptance/application_spec.rb" with:
      """
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
      """
    When I run the rake task "spec"
    Then I see a successful response in the shell
