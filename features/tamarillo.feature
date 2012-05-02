Feature: tamarillo

  Scenario: First usage
    Given there is no active tomato
    When I run `tam`
    Then the exit status should be 0
    Then the output should be nothing

  Scenario: Starting a tomato
    Given the default configuration
    And there is no active tomato
    When I run `tam start`
    Then the exit status should be 0
    Then the output should match:
    """
    25:00
    """
  
  Scenario: Tomato status
  Given the default configuration
  And there is an active tomato
  When I run `tam`
  Then the output should match:
  """
  10:32
  """

  Scenario: Interrupting a tomato
    Given there is an active tomato
    When I run `tam interrupt'
    Then pending
