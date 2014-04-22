Feature: Backend connection
  Testing to make sure the backend and frontend can successfully communicate.

  Scenario: Basic test
    Then the backend is connected
    When "illinois,michigan" are sent to the backend
    Then it should return "illinois,michigan"
    When "michigan,texas,alaska" are sent to the backend
    Then it should return "texas,alaska,michigan"
    When "san jose,charleston,qdoba,a,b,c" are sent to the backend
    Then it should return "charleston,san jose,qdoba,a,b,c"

  Scenario: Reconnect
     When "check1,random,crazy13,bumby,zP,10,9,8,7,6" are sent to the backend
     Then it should return "check1,random,crazy13,bumby,zP,10,9,8,7,6"
