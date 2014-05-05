@javascript
Feature: Front end
  Scenario: Loading the bracket
    Given the bracket test teams are loaded
    And I'm on the bracket page
    Then all predictions should be there

  Scenario: Viewing the team rank
    Given the team rank test teams are loaded
    And I'm on the rank page
    Then Florida should be ranked 1
    And Illinois should be ranked 2
    And Mercer should be ranked 3
