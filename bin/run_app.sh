#!/usr/bin/env bash
bundle exec rackup --port 7000 config.ru -E ${RACK_ENV:-development}