#!/usr/bin/env ruby
# frozen_string_literal: true
# -*- coding: UTF-8 -*-

require 'httparty'
require 'thor'

module PAGER
  module COMMANDS
    class List < Thor

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
        @schedule_url = @base_url + "/schedules"
      end

      desc "on_calls", "list on calls"
      def on_calls
        response = HTTParty.get(@on_call_url, headers: @headers)
        puts response
        response['oncalls'].each do |oncall|
          puts "> On Calls: #{oncall['name']}"
          puts ">> Users:"
          puts ">>> #{oncall['users']}"
        end
      end

      desc "schedules", "list schedules"
      def schedules
        response = HTTParty.get(@schedule_url, headers: @headers)
        response['schedules'].each do |schedule|
          puts "Schedule: #{schedule['name']}"
          puts "* Users:"
          schedule['users'].each do |user|
            puts "  * #{user['summary']}"
          end
        end
      end

      # TODO: Need to find out how to evaluate appropriately
      desc "schedule", "list a specific schedule"
      def schedule(id)
        response = HTTParty.get(@schedule_url, headers: @headers)
        response['schedules'].each do |schedule|
          if schedule['id'] || schedule['name'] == id
            puts "Schedule: #{schedule['name']}"
            puts "* Users:"
            schedule['users'].each do |user|
              puts "  * #{user['summary']}"
            end
          end
        end
      end

      desc "incidents", "list all incidents"
      def incidents
        response = HTTParty.get(@incident_url, headers: @headers)
        puts response
      end

      desc "incident", "list specific incident"
      def incident(id)
        response = HTTParty.get(@incident_url, headers: @headers)
        puts response
      end

    end
  end
end
