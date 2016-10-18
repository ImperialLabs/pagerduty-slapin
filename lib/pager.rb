#!/usr/bin/env ruby
# frozen_string_literal: true
# -*- coding: UTF-8 -*-

require "pagerduty/version"
require "thor"

Dir["#{File.dirname(__FILE__)}/Pager/*.rb"].each { |item| load(item) }

module PAGER
  class PAGERCLI < Thor

    attr_accessor :out

    def initialize(*args)
      super
      @out = $stdout
    end

    desc "list", "list a incident"
    subcommand "list", PAGER::INCIDENT.list

    desc "list-all", "list all incidents"
    subcommand "list-all", PAGER::INCIDENT.list-all

    desc "list-notes", "list notes for a incident"
    subcommand "list-notes", PAGER::INCIDENT.list-notes

    desc "update", "update a incident"
    subcommand "update", PAGER::INCIDENT.update

    desc "create-note", "create a incident note"
    subcommand "create-note", PAGER::INCIDENT.create-note

    desc "list", "list on calls"
    subcommand "list", PAGER::ONCALL.list

    desc "list", "list schedules"
    subcommand "list", PAGER::SCHEDULE.list

    desc "version", "Get the version of the Pager Tool"

    def version
      @out.puts "pager version #{PAGER::VERSION}"
    end

  end
end
