Feature: jse matches specific fields within the json

  Scenario: Exact match on one field
    Given I have a log file containing:
    """
    {"level":"INFO","message":"line one"}
    {"level":"DEBUG","message":"line two"}
    {"level":"ERROR","message":"line three"}
    {"level":"INFO","message":"line four"}
    """
    When I run "jse level:INFO" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"INFO","message":"line four"}
    """

  Scenario: Exact match on multiple fields
  Scenario: Regexp match on one field
  Scenario: Regexp match on multiple fields
