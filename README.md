# GSoC 2017 Joomla PR Testing Platform

## What is this?
---------------------
* This is a platform meant for allowing users to test PRs more easily without much effort or knowledge to setup the Joomla instance for the PR to be tested
* After all tests pass on a PR a URL will be posted into that PR that will lead to a website with github authentication where the user will request his desired environment to test the PR. 
* The user will be presented with options to configure the server for the intended test request, like DB, PHP versions, etc. And then the user is redirected to the Joomla! Instance for testing.

## Installing
---------------------

### Install Dependencies with Composer

```
composer install
```
