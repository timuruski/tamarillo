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
    Then the output should match /About \d+ minutes/
      And the exit status should be 0

  Scenario: Tomato status
    Given there is an active tomato
    When I run `tam`
    Then the output should match /About \d+ minutes/

  Scenario: Interrupting a tomato
    Given there is an active tomato
    When I run `tam interrupt`
    And I run `tam`
    Then the output should be empty

  Scenario: A tomato is completed
    Given there is a completed tomato
    When I run `tam`
    Then the output should be empty

  Scenario: Invalid command
    When I run `tam blah`
    Then the exit status should be 1
    And the output should contain:
    """
    Invalid command 'blah'
    """

  Scenario: Tomato status for prompt
    Given there is an active tomato
    When I run `tam status --prompt`
    Then the output should match:
    """
    \d\d:\d\d \d{4} \d{4}
    """

