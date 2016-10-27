#!/usr/bin/env ruby
# frozen_string_literal: true
# -*- coding: UTF-8 -*-

require "thor"
require "pager/version"

Dir["#{File.dirname(__FILE__)}/pager/commands/*.rb"].each { |item| load(item) }

module PAGER
  class PAGERCLI < Thor

    def initialize(*args)
      super
    end

    desc "list", "list items"
    subcommand "list", PAGER::COMMANDS::List

    desc "create", "create items"
    subcommand "create", PAGER::COMMANDS::Create

    desc "delete", "delete items"
    subcommand "delete", PAGER::COMMANDS::Delete

    desc "update", "update items"
    subcommand "update", PAGER::COMMANDS::Update

    desc "trigger", "trigger incident"
    subcommand "trigger", PAGER::COMMANDS::Trigger

    desc "ack", "acknowledge incident"
    subcommand "ack", PAGER::COMMANDS::Ack

    desc "resolve", "resolve incident"
    subcommand "resolve", PAGER::COMMANDS::Resolve

    desc "version", "Get the version of the Pager Tool"
    def version
      puts "pager version #{PAGER::VERSION}"
    end
  end
end
