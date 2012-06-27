Feature: configuration

  Scenario: Outputting the current config
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
    And I run `tam status`
    Then the output should contain:
    """
    about 5 minutes
    """
    And the output should not contain:
    """
    about 25 minutes
    """
