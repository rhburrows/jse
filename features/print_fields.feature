Feature: jse prints specific fields from the json

  In order to only show relevant information
  As a jse user
  I want to only output specific json fields

  Background:
  Given I have a log file containing:
    """
    {"id":1,"level":"INFO","message":"line one"}
    {"id":2,"level":"DEBUG","message":"line two"}
    {"id":3,"level":"ERROR","message":"number three"}
    {"id":4,"level":"INFO","message":"line four"}
    """
  
  Scenario: Printing one field returns just the value
    When I run "jse --fields=message" on my log file
    Then I should see:
    """
    line one
    line two
    number three
    line four
    """

  Scenario: Printing multiple fields returns JSON
    When I run "jse --fields=message,level" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"DEBUG","message":"line two"}
    {"level":"ERROR","message":"number three"}
    {"level":"INFO","message":"line four"}
    """

  Scenario: Fields can be specified with a shorter '-f' flag
    When I run "jse -f message,level" on my log file
    Then I should see:
    """
    {"level":"INFO","message":"line one"}
    {"level":"DEBUG","message":"line two"}
    {"level":"ERROR","message":"number three"}
    {"level":"INFO","message":"line four"}
    """
