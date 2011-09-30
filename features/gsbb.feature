Feature: I can run my executable directly

  Scenario: Executable works
    When I run the app without parameters
    Then the exit status should be 0

  Scenario: Executable displays available commands
    When I run the app without parameters
    Then the output shows available commands

  Scenario: Uses command line if local repository present
    Given I have stale branches
    When I run `gsbb show`
    Then the output includes the stale branches