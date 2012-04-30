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

  Scenario: setting invalid duration
    Given the default configuration
    When I run `tam config duration=invalid_input`
    And I run `tam config`
    Then the exit status should be 0
    Then the output should contain:
    """
    duration: 25
    """
