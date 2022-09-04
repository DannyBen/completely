Change Log
========================================

v0.5.0 - 2022-09-04
----------------------------------------

- Add docker release
- Fix shellcheck SC2162 in the generated script
- Fix shellcheck SC2124 in the generated script
- Hide flag completion unless input ends with a hyphen


v0.4.3 - 2022-07-14
----------------------------------------

- Fix file/folder completion when they contain spaces


v0.4.2 - 2022-05-27
----------------------------------------

- Allow keeping the test script with --keep


v0.4.1 - 2022-05-21
----------------------------------------

- Remove support for arbitrary script test to fix zsh incompatibilities


v0.4.0 - 2022-05-21
----------------------------------------

- Improve template
- Refactor CLI commands
- Add Tester class for testing any completions script
- Add tester CLI command
- Add support for middle wildcard for --flag args completions
- Add COMPLETELY_DEBUG environment setting
- Allow setting the CONFIG_PATH argument via the COMPLETELY_CONFIG_PATH environment variable
- Allow setting the SCRIPT_PATH argument via the COMPLETELY_SCRIPT_PATH environment variable


v0.3.1 - 2022-02-20
----------------------------------------

- Fix Psych 4 errors for Ruby 3.1


v0.3.0 - 2022-01-28
----------------------------------------

- Fix generated script for zsh compatibility


v0.2.0 - 2021-09-03
----------------------------------------

- Improve generated code to support local completions


v0.1.3 - 2021-07-21
----------------------------------------

- Fix function name when only spaced patterns are configured


v0.1.2 - 2021-07-20
----------------------------------------

- Add ability to generate a function that prints the script


v0.1.1 - 2021-07-20
----------------------------------------

- Fix missing VERSION error


v0.1.0 - 2021-07-20
----------------------------------------

- Initial version


