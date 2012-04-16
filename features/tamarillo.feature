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
