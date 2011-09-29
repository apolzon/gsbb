Feature: I can run my executable directly

  Scenario: Executable works
    When I run the app without parameters
    Then the exit status should be 0

  Scenario: Executable displays available commands
    When I run the app without parameters
    Then the output shows available commands