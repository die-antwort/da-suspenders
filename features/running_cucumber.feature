Feature: Running cucumber in the generated project
  
  Scenario: jQuery and Modernizr work in the generated project
    Given I drop and create the required databases
    And I generate "scaffold user username:string"
    And I run the rake task "db:migrate"
    And I create a file named "features/js_test.feature" with:
      """
      Feature: Javascript
        @javascript
        Scenario: Test jQuery and Modernizr
          When I go to "the users page"
          Then the javascript expression "$('html').hasClass('js')" should return "true"
          And the javascript expression "$('html').hasClass('no-js')" should return "false"
      """
    When I run the rake task "cucumber"
    Then I see a successful response in the shell
  