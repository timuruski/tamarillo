Feature: tamarillo

  Scenario: First usage
    Given there is no active tomato
    When I run `tam`
    Then the exit status should be 0
    Then the output should be empty

  Scenario: Starting a tomato
    Given the default configuration
      And there is no active tomato
    When I run `tam start`
    Then the output should match /\d+:\d+/
      And the exit status should be 0
  
  Scenario: Tomato status
  Given there is an active tomato
  When I run `tam`
  Then the output should match /\d+:\d+/

  Scenario: Interrupting a tomato
    Given there is an active tomato
    When I run `tam interrupt`
    And I run `tam`
    Then the output should be empty
