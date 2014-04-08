@javascript
Feature: Game prediction
  Select from a list of teams to pick two teams to match up. It sends an AJAX
  request to the server which predicts the results of a game.

  Background:
    Given the test teams are loaded
    And I am on the prediction page

  Scenario: Picking the same team
    When I ask for a prediction
    Then it should show an error
    And it should have the error css class

  Scenario: Getting a prediction
    When I select "UIUC" for team 1
    And I ask for a prediction
    Then it should show that "UIUC" wins

  Scenario: Clearing an error on select change
    When I ask for a prediction
    Then it should show an error
    And it should have the error css class
    When I select "UIUC" for team 1
    Then it should not show a prediction
    And it should not have the error css class

  Scenario: Clearing a prediction on select change
    When I select "UIUC" for team 1
    And I ask for a prediction
    Then it should show that "UIUC" wins
    When I select "IU" for team 1
    Then it should not show a prediction
