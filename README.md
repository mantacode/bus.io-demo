[![Build Status](https://travis-ci.org/mantacode/bus.io-demo.svg?branch=master)](https://travis-ci.org/mantacode/bus.io-demo)

A bus.io-demo!

# Installation and Environment Setup

Install node.js (See download and install instructions here: http://nodejs.org/).

Clone this repository

    > git clone git@github.com:mantacode/bus.io-demo.git

cd into the directory and install the dependencies

    > cd bus.io-demo
    > npm install && npm shrinkwrap --dev

# Running Tests

Install coffee-script

    > npm install coffee-script -g

Tests are run using grunt.  You must first globally install the grunt-cli with npm.

    > sudo npm install -g grunt-cli

## Unit Tests

To run the tests, just run grunt

    > grunt spec
