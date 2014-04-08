Feature: Backend connection
  Testing to make sure the backend and frontend can successfully communicate.

  Scenario: Basic test
    Given the backend is connected
    When "illinois" and "michigan" are sent to the backend
    Then it should return "illinois"
    When "illinois" and "san jose" are sent to the backend
    Then it should return "san jose"
    When "illinois" and "arizona" are sent to the backend
    Then it should return "arizona"

