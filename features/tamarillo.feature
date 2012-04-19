Feature: tamarillo
  In order to get busy
  As a developer
  I want to use Aruba + Cucumber


  Scenario: App works
    When I run `tam`
    Then the output should contain:
    """
    No tomatoes in progress
    """

  Scenario: First run
    Given I have no active tomato
    And I have no previous tomatoes
    When I run `tam`
    Then pending

  Scenario: Starting a tomato
    Given I have no active tomato
    When I run `tam start "Some task I'm working on"`
    Then pending

  Scenario: Interrupting a tomato
    Given I have an active tomato
    When I run `tam interrupt'
    Then pending

  Scenario: Cleaning up
    Given I have tomatoes from last month
    When I run `tam cleanup`
    Then pending
