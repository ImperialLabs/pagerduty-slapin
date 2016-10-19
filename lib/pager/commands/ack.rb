#!/usr/bin/env ruby
# frozen_string_literal: true
# -*- coding: UTF-8 -*-

require 'httparty'
require 'thor'

module PAGER
  module COMMANDS
    class Ack < Thor

      def initialize(*args)
        super
        config_file = 'config/pager.yml'
        @config = YAML.load_file(config_file) if File.file?(config_file)
        @base_url = 'https://api.pagerduty.com'
        @token = @config['token'] || ENV['PAGER_TOKEN']
        @headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/vnd.pagerduty+json;version=2',
          'Authorization' => "Token token=#{@token}"
        }
        @incident_url = @base_url + "/incidents"
        @on_call_url = @base_url + "/oncalls"
      end

      desc "incident", "acknowledge a incident"
      def incident
        response = HTTParty.get(@incident_url, @headers)
        puts response
      end

    end
  end
end
