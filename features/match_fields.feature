Feature: jse matches specific fields within the json

  In order to identify important lines
  As a jse user
  I want to filter my json by values in the specific fields

  Background:
  Given I have a log file containing:
    """
    {"level":"INFO","message":"line one"}
    {"level":"DEBUG","message":"line two"}
    {"level":"ERROR","message":"number three"}
    {"level":"INFO","message":"line four"}
    """

  Scenario: Exact match on one field
    When I run "jse level:INFO" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"INFO","message":"line four"}
    """
    But I should not see:
    """
    {"level":"DEBUG","message":"line two"}
    {"level":"ERROR","message":"number three"}
    """

  Scenario: Exact match on multiple fields
    When I run "jse level:INFO message:'line one'" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    """
    But I should not see:
    """
    {"level":"INFO","message":"line four"}
    """

  Scenario: Regexp match on one field
    When I run "jse message:/^line/" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"DEBUG","message":"line two"}
    {"level":"INFO","message":"line four"}
    """
    But I should not see:
    """
    {"level":"ERROR","message":"number three"}
    """

  Scenario: Regexp match on multiple fields
    When I run "jse level:/O$/ message:/^line/" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"INFO","message":"line four"}
    """
    But I should not see:
    """
    {"level":"DEBUG","message":"line two"}
    {"level":"ERROR","message":"number three"}
    """

  Scenario: Both Exact an Regexp match in one
    When I run "jse level:/INFO/ message:/^line/" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"INFO","message":"line four"}
    """
    But I should not see:
    """
    {"level":"DEBUG","message":"line two"}
    {"level":"ERROR","message":"number three"}
    """

  Scenario: Case insensitive exact matching
    When I run "jse level:info -i" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"INFO","message":"line four"}
    """
    But I should not see:
    """
    {"level":"DEBUG","message":"line two"}
    {"level":"ERROR","message":"number three"}
    """

  Scenario: Case insensitive regexp matching
    When I run "jse message:/^LINe/ -i" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"INFO","message":"line four"}
    {"level":"DEBUG","message":"line two"}
    """
    But I should not see:
    """
    {"level":"ERROR","message":"number three"}
    """
