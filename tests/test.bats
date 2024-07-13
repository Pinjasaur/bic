#!/usr/bin/env bats
#
# Welcome to bic's minimal test suite. Each subdirectory models a directory
# where bic may be ran in order to assert behaviors based on the state of the
# file structure.

@test "bic --help prints usage & exits cleanly" {
  run ./bic --help
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${status}" == 0 ]]
}

@test "bic bails on empty directory" {
  run ./bic tests/empty
  [[ "${status}" != 0 ]]
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

@test "bic builds pages/ correctly" {
  run ./bic tests/pages
  [[ -f tests/pages/build/page.html ]]
  [[ "${status}" == 0 ]]
  rm -rf tests/pages/build
  [[ ! -d tests/pages/build ]]
}

@test "bic builds posts/ correctly" {
  run ./bic tests/posts
  [[ -f tests/posts/build/hello-world.html ]]
  [[ "${status}" == 0 ]]
  rm -rf tests/posts/build
  [[ ! -d tests/posts/build ]]
}

@test "bic builds drafts/ correctly" {
  run ./bic tests/drafts
  [[ -f tests/drafts/build/drafts/untitled.html ]]
  [[ "${status}" == 0 ]]
  rm -rf tests/drafts/build
  [[ ! -d tests/drafts/build ]]
}

@test "bic builds robots.txt correctly" {
  run ./bic tests/robots
  [[ -f tests/robots/build/robots.txt ]]
  [[ "${status}" == 0 ]]
  run cat tests/robots/build/robots.txt
  [[ "${lines[0]}" == "# Test :)" ]]
  rm -rf tests/robots/build
  [[ ! -d tests/robots/build ]]
}

@test "bic will not overwrite by default" {
  run ./bic tests/overwrite
  [[ -f tests/overwrite/build/test.html ]]
  [[ "${status}" != 0 ]] # errored out trying to overwrite test.html
  run cat tests/overwrite/build/test.html
  [[ "${lines[0]}" == "<p>page</p>" ]]
  rm -rf tests/overwrite/build
  [[ ! -d tests/overwrite/build ]]
}

@test "bic will overwrite if specified" {
  BIC_OVERWRITE=1 run ./bic tests/overwrite
  [[ -f tests/overwrite/build/test.html ]]
  [[ "${status}" == 0 ]] # didn't error out
  run cat tests/overwrite/build/test.html
  [[ "${lines[0]}" == "<p>post</p>" ]]
  rm -rf tests/overwrite/build
  [[ ! -d tests/overwrite/build ]]
}

@test "bic will honor a custom \$BUILD_DIR" {
  BUILD_DIR=_site run ./bic tests/index.html
  [[ -f tests/index.html/_site/index.html ]]
  [[ "${status}" == 0 ]]
  rm -rf tests/index.html/_site
  [[ ! -d tests/index.html/_site ]]
}

@test "bic bails if first line isn't top-level heading" {
  run ./bic tests/heading
  [[ "${status}" != 0 ]] # errored out because badly formed .md file
  rm -rf tests/heading/build
  [[ ! -d tests/heading/build ]]
}

@test "bic bails if no number prefix" {
  run ./bic tests/id
  [[ "${status}" != 0 ]] # errored out because badly named .md file
  rm -rf tests/id/build
  [[ ! -d tests/id/build ]]
}

@test "bic uses custom .env files" {
  run ./bic tests/.env
  [[ "${status}" == 0 ]]
  run cat tests/.env/build/index.html
  [[ "${lines[0]}" == "monkey" ]]
  rm -rf tests/.env/build
  [[ ! -d tests/.env/build ]]
}

@test "bic uses runtime ENV_VAR=values" {
  SITE_URL='http://domain.tld' run ./bic tests/env-var
  [[ "${status}" == 0 ]]
  run cat tests/env-var/build/feed.rss
  [[ "${lines[0]}" == "http://domain.tld" ]]
  rm -rf tests/env-var/build
  [[ ! -d tests/env-var/build ]]
}

@test "bic allows for overridable .env" {
  run ./bic tests/.env-defaults
  [[ "${status}" == 0 ]]
  run cat tests/.env-defaults/build/index.html
  [[ "${lines[0]}" == "bar" ]]
  rm -rf tests/.env-defaults/build
  [[ ! -d tests/.env-defaults/build ]]

  # run again, this time supplying a runtime definition of the env var
  FOO=baz run ./bic tests/.env-defaults
  [[ "${status}" == 0 ]]
  run cat tests/.env-defaults/build/index.html
  [[ "${lines[0]}" == "baz" ]]
  rm -rf tests/.env-defaults/build
  [[ ! -d tests/.env-defaults/build ]]
}

@test "bic doesn't allow posts with a pipe '|' in the filename" {
  run ./bic tests/no-pipe
  [[ "${status}" != 0 ]]
  [[ "${output}" == *"cannot contain a pipe literal"* ]]
  rm -rf tests/no-pipe/build
  [[ ! -d tests/no-pipe/build ]]
}


@test "bic does basic tags" {
  run ./bic tests/tags
  [[ "${status}" == 0 ]]
  # rm -rf tests/id/build
  # [[ ! -d tests/id/build ]]
}
