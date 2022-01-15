#!/usr/bin/env bats
#
# Welcome to bic's minimal test suite. Each subdirectory models a directory
# wherembic may be ran in order to assert behaviors based on the state of the
# file structure.

@test "bic --help prints usage & exits cleanly" {
  run ./bic --help
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${status}" == 0 ]]
}

@test "bic bails on empty directory" {
  run ./bic tests/empty
  [[ "${status}" == 1 ]]
}

@test "bic works with an {,__}index.html" {
  run ./bic tests/index.html
  [[ -f tests/index.html/build/index.html ]]
  [[ "${status}" == 0 ]]
  rm -rf tests/index.html/build
  [[ ! -d tests/index.html/build ]]
}

@test "bic copies static/ correctly" {
  run ./bic tests/static
  [[ -f tests/static/build/humans.txt ]]
  [[ "${status}" == 0 ]]
  rm -rf tests/static/build
  [[ ! -d tests/static/build ]]
}
