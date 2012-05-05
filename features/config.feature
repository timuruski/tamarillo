Feature: configuration

  Scenario: Outputting the currng config
    Given the default configuration
    When I run `tam config`
    Then the exit status should be 0
    Then the output should contain:
    """
    duration: 25
    """

  Scenario: Setting the tomato duration
    Given the default configuration
    When I run `tam config duration=15`
    And I run `tam config`
    Then the exit status should be 0
    Then the output should contain:
    """
    duration: 15
    """

  Scenario: Setting invalid duration
    Given the default configuration
    When I run `tam config duration=invalid_input`
    And I run `tam config`
    Then the exit status should be 0
    Then the output should contain:
    """
    duration: 25
    """

  Scenario: Changing the tomato duration
    Given there is no active tomato
    When I run `tam config duration=5`
    And I run `tam start`
    And I run `tam`
    Then the output should contain:
    """
    About 5 minutes
    """
    And the output should not contain:
    """
    About 25 minutes
    """
