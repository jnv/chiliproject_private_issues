# Private Issues plugin for ChiliProject [![Build Status](https://secure.travis-ci.org/jnv/chiliproject_private_issues.png?branch=master)](http://travis-ci.org/jnv/chiliproject_private_issues)

Allows individual issues to be marked as private. These issues are can be viewed only by roles with "View private issues" permission. This is similar to the standard functionality in Redmine (see [ChiliProject's bugtracker](https://www.chiliproject.org/issues/189)).

## Installation

1. Follow the instructions at https://www.chiliproject.org/projects/chiliproject/wiki/Plugin_Install
2. Two new permissions will be available for roles: "View private issues" and "Manage private issues" (to manage privacy of the issue)

## Compatibility

Plugin was tested with:

* ChiliProject 3.3.0
* Ruby 1.9.3p327

## Testing

Patches, pull requests and forks are welcome, but if possible, provide proper test coverage.

You can also use [Travis-CI](http://travis-ci.org/) integration based on the [chiliproject_test_plugin](https://github.com/jnv/chiliproject_test_plugin).

For running tests, see also [Redmine's instructions](http://www.redmine.org/projects/redmine/wiki/Plugin_Tutorial#Running-test).

Setup and migrate your test database:

```
bundle exec rake db:drop db:create db:migrate redmine:load_default_data db:migrate:plugins RAILS_ENV=test
```

To run tests, execute the following task from main ChiliProject's directory:

```
bundle exec rake test:engines:all PLUGIN=chiliproject_private_issues
```

You can also execute individual test files, however you need to run this rake task before execution:

```
bundle exec rake test:plugins:setup_plugin_fixtures
```

## License

This plugin is licensed under the GNU GPL v2. See COPYRIGHT.txt and LICENSE.txt for details.
