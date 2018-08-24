Feature: "test" command
  Scenario: First Run of Command
    Given a file named "cli.sh" with:
    """
    echo "Hello, Aruba!"
    """
    When I successfully run `bash ./cli.sh`
    Then the output should contain:
    """
    Hello, Aruba!
    """

# Interactive step
  Scenario: Run command
  When I run `cat` interactively
  And I type "Hello, world"
  And I type ""
  Then the output should contain "Hello, world"

#Regrex match
  Scenario: run regrex-cli command
    Given a file named "aruba-test-cli.sh" with:
    """
    echo "Hello, Aruba!"
    """
    When I run `bash aruba-test-cli.sh`
    Then the output should match /^Hello(, world)?/