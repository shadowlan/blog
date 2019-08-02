# Behavior Driven Development

## Reference
*Offical Doc*
* [BDD][bdd-definition]
* [Cucumber][Cucumber] Cucumber is a tool that supports Behaviour-Driven Development(BDD). Cucumber reads executable specifications written in plain text and validates that the software does what those specifications say. The specifications consists of multiple examples, or scenarios. 
* [Aruba][Aruba] Aruba is an extension for popular TDD and BDD frameworks like "Cucumber", "RSpec" and "Minitest" to make testing of commandline applications meaningful, easy and fun.
* [Gherkin][Gherkin] Gherkin uses a set of special keywords to give structure and meaning to executable specifications. Each keyword is translated to many spoken languages; 

## Installation

1. Install through gem directly
```bash
gem install cucumber
gem install aruba
```
2. install with gemfile
```bash
cat << EOF >> gemfile
source "https://rubygems.org"
group :bdd do
  gem 'cucumber', '~> 3.1.0'
  gem 'rspec', '~> 3.7.0'
end
EOF
bundle install
cucumber --init
```

# Cucumber

## Basic

* In Cucumber, an example is called a Scenario. Scenarios are defined in .feature files, which are stored in the features directory (or a subdirectory).

## Execution order

* Alphabetically by feature file directory
* Alphabetically by feature file name
* Order of scenarios within the feature file
* Given order: cucumber folder1/file1 folder0/file0

## Tag
Tag expressions let you select a subset of scenarios, based on tags. They can be used for two purposes:
* Running a subset of scenarios
  `cucumber --tags "@smoke and @fast"`
* Scoping hooks to a subset of scenarios
  ```
  Before('@browser and not @headless') do
    #dosomething before running those matched scenarios
  end
  ```
Tag operator: and/or/not
Sample:
 * @wip and not @slow
 * @smoke and @fast
 * @gui or @database
 * (@smoke or @ui) and (not @slow)

## Hook
Hooks are blocks of code that can run at various points in the Cucumber execution cycle. They are typically used for setup and teardown of the environment before and after each scenario.
* Global hook
```ruby
my_heavy_object = HeavyObject.new
my_heavy_object.do_it
at_exit do
  my_heavy_object.undo_it
end
```
* before/after hook
```ruby
Before do
  # Do something before each scenario
end
After do |scenario|
end
```
* hook with tag
```ruby
Before('@browser and not @headless' do
end
```
* [more hooks][MoreHooks]

## Profile
Specify configuration options for Cucumber in a cucumber.yml or cucumber.yaml file, must be in a .config directory, or config subdirectory of your current working directory. [more about profile][MoreAboutProfile]
```yaml
default: --profile html_report --profile bvt
html_report: --format progress --format html --out=features_report.html
bvt: --tags @bvt
```
Run with profile `cucumber -p html_report`

## CLI Tips

* set env variables: `cucumber Foo=bar`

# Aruba

## Project Initilization

Initialize project with aruba using cucumber framework: `aruba init --test-framework cucumber`

Create a file named "features/support/env.rb" with:
```
require 'aruba/cucumber'
```
Create a file named "features/use_aruba_with_cucumber.feature" with:

```
Feature: Cucumber
  Scenario: First Run
    Given a file named "file.txt" with:
    """
    Hello World
    """
    Then the file "file.txt" should contain:
    """
    Hello World
    """
```
Run `cucumber`

## Configuration
You can configure aruba in two ways:
  * Using Aruba.configure -block
  ```ruby
  Aruba.configure do |config|
    config.exit_timeout = 1
  end
  ```
  * Using aruba.config.<option> = <value>
  ```ruby
  Before '@slow-command' do
    aruba.config.exit_timeout = 5
  end
  ```

## Variables
* Set environment variable, it will overwrite an existing one
```ruby
Feature: Environment Variable
  Scenario: Run command
    #simple one with one line: Given I set the environment variable "LONG_LONG_VARIABLE" to "long_value"
    Given I set the environment variables to:
      | variable           | value      |
      | LONG_LONG_VARIABLE | long_value |
    When I run `aruba-test-cli`
    Then the output should contain:
    """
    long_value
    """
```

* Append environment variable
```ruby
Feature: Environment Variable
  Scenario: Run command
    # append the "long_value" to variable "LONG_LONG_VARIABLE"
    Given I append the values to the environment variables:
      | variable           | value      |
      | LONG_LONG_VARIABLE | long_value |
    When I run `aruba-test-cli`
    Then the output should contain:
    """
    1long_value
    """
```

## Run Command

* Check result with regrex
```ruby
Feature: Run command
  Scenario: run regrex-cli command
    Given a file named "aruba-test-cli.sh" with:
    """
    echo "Hello, Aruba!"
    """
    When I run `bash aruba-test-cli.sh`
    Then the output should match /^hello(, world)?/
```
* Interactively Binary
```ruby
Feature: Run command
  Scenario: Run command
  When I run `cat` interactively
  And I type "Hello, world"
  And I type ""
  Then the output should contain "Hello, world"
```
## Tips

* @no-clobber tag to disable clean up Aruba working directory for each scenario
* show step definitions that are currently defined `cucumber --format stepdefs`

# Other links

* [BDD vs TDD][bdd-cn]
* [5 Steps Guide for Cucumber][5-step-guide]
* [Specify Execution Order in Cucumber][execution-order]
* [Test Commandline Apps][test-cli]
* [Cucumber books][cucumber-books]

[Aruba]: https://app.cucumber.pro/projects/aruba/documents/branch/master
[Cucumber]: https://docs.cucumber.io/cucumber/
[bdd-definition]: https://www.agilealliance.org/glossary/bdd
[bdd-cn]: https://medium.com/@yurenju/%E8%87%AA%E5%8B%95%E8%BB%9F%E9%AB%94%E6%B8%AC%E8%A9%A6-tdd-%E8%88%87-bdd-464519672ac5
[5-step-guide]: https://www.agiletrailblazers.com/blog/the-5-step-guide-for-selenium-cucumber-and-gherkin
[execution-order]: https://jkotests.wordpress.com/2013/08/22/specify-execution-order-of-cucumber-features/
[test-cli]: https://www.aktuellum.com/mobile/ruby/ex4/
[cucumber-books]: http://toolsqa.com/cucumber/cucumber-hooks/
[MoreHooks]: https://docs.cucumber.io/cucumber/api/#tagged-hooks
[MoreAboutProfile]: https://docs.cucumber.io/cucumber/configuration/#default-profile
[Gherkin]:https://docs.cucumber.io/gherkin/reference/