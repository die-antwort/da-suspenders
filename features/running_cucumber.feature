Feature: Running cucumber in the generated project
  
  Scenario: The generated project works correctly
    Given I drop and create the required databases
    And I generate "scaffold user username:string"
    And I run the rake task "db:migrate"
    And I create a file named "features/test.feature" with:
      """
      Feature: The application works correctly
      
        @javascript
        Scenario: jQuery and Modernizr work correctly
          When I visit the users page
          Then the javascript expression "$('html').hasClass('js')" should return "true"
          And the javascript expression "$('html').hasClass('no-js')" should return "false"

        Scenario: Stylesheets are generated correctly
          Given there are no cached assets
          When I visit the application stylesheet
          Then it should contain the css rules from formtastic
      """
    And I create a file named "features/step_definitions/test_steps.rb" with:
      """
      When /^I visit the users page/ do
        visit "/users"
      end
      
      Given /^there are no cached assets$/ do
        FileUtils.rm_rf ["#{Rails.root}/tmp/cache/assets", "#{Rails.root}/tmp/cache/sass"]
      end

      When /^I visit the application stylesheet$/ do
        visit "/assets/application.css"
      end

      Then /^it should contain the css rules from formtastic$/ do
        page.should have_content ".formtastic"
      end
      """
    When I run the rake task "cucumber"
    Then I see a successful response in the shell
  