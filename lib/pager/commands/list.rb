#!/usr/bin/env ruby
# frozen_string_literal: true
# -*- coding: UTF-8 -*-

require 'httparty'
require 'thor'
require 'yaml'
require 'date'
require 'pp'

module PAGER
  module COMMANDS
    class List < Thor
      # Initialize config file
      # Evaluates all possible config locations
      # Build out base urls
      # Will raise error if Token is not available
      def initialize(*args)
        super
        if File.file?(File.join(__dir__, '../../../config/pager.local.yml'))
          config_file = File.join(__dir__, '../../../config/pager.local.yml')
        elsif File.file?(File.join(__dir__, '../../../config/pager.yml'))
          config_file = File.join(__dir__, '../../../config/pager.yml')
        else
          config_file = nil
        end

        @config = file_check(config_file) ? YAML.load_file(config_file) : {}
        @base_url = 'https://api.pagerduty.com'
        raise 'You need to set config file or PAGER_TOKEN environment variable' if @config.dig('pager', 'token') && ENV['PAGER_TOKEN'].nil?
        @token = @config.dig('pager', 'token') ? @config['pager']['token'] : ENV['PAGER_TOKEN']
        @headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/vnd.pagerduty+json;version=2',
          'Authorization' => "Token token=#{@token}"
        }
        @incident_url = @base_url + '/incidents'
        @on_call_url = @base_url + '/oncalls'
        @schedule_url = @base_url + '/schedules'
        @services_url = @base_url + '/services'
      end

      # List all services
      desc 'services', 'list all services'
      def services
        response = HTTParty.get(@services_url, headers: @headers)
          #puts "The following is a list of all services under your account"
        response['services'].each do |services|
          puts "Service Name: #{services['name']}"
          puts "Service Description: #{services['description']}"
          puts "Service Status: #{services['status']}"
          puts "* Team Name: #{services['teams'][0]['type']}"
          puts "_________________________________________________"
        end
      end

      # List all on calls
      desc 'on_calls', 'list on calls'
      def on_calls
        response = HTTParty.get(@on_call_url, headers: @headers)
        response['oncalls'].each do |oncall|
          if oncall['start'].nil? && oncall['end'].nil?
             # Do nothing, not on call
             # TODO: Log?
             # TODO: change to unless?
          elsif oncall['end'].nil?
             start_time = DateTime.parse(oncall['start']).strftime('%d-%b-%Y %I:%M%P')
             end_time = "ETERNITY"
              puts "On Call For Schedule: #{oncall['schedule']['summary']} (#{oncall['schedule']['id']})"
              puts "* Policy Summary: #{oncall['escalation_policy']['summary']}"
              puts '* User:'
              puts "  * #{oncall['user']['summary']}"
              puts "    * On Call Period: #{start_time} - #{end_time}"
          else
              start_time = DateTime.parse(oncall['start']).strftime('%d-%b-%Y %I:%M%P')
              end_time = DateTime.parse(oncall['end']).strftime('%d-%b-%Y %I:%M%P %Z')
              puts "On Call For Schedule: #{oncall['schedule']['summary']} (#{oncall['schedule']['id']})"
              puts "* Policy Summary: #{oncall['escalation_policy']['summary']}"
              puts '* User:'
              puts "  * #{oncall['user']['summary']}"
              puts "    * On Call Period: #{start_time} - #{end_time}"
          end
        end
      end

      # List all schedules
      desc 'schedules', 'list schedules'
      def schedules
        response = HTTParty.get(@schedule_url, headers: @headers)
        response['schedules'].each do |schedule|
          puts "Schedule: #{schedule['name']} (#{schedule['id']})"
        end
      end

      # Lists a specific schedule's info and will indicate who's on call for that schedule
      desc 'schedule', 'list a specific schedule'
      def schedule(id)
        get_schedule = HTTParty.get("#{@schedule_url}/#{id}", headers: @headers)
        get_oncall = HTTParty.get(@on_call_url, headers: @headers)
        get_schedule['schedule']['escalation_policies'].each do |policy|
          get_oncall['oncalls'].each do |oncall|
            unless oncall['start'].nil? && oncall['end'].nil?
              @on_call_user = oncall['user']['summary'] if oncall['escalation_policy']['id'] == policy['id']
              @end_time = DateTime.parse(oncall['end']).strftime('%d-%b-%Y %I:%M%P %Z')
            end
          end
        end
        puts "Schedule: #{get_schedule['schedule']['name']} (#{get_schedule['schedule']['id']})"
        puts "URL: #{get_schedule['schedule']['html_url']}"
        puts '* Users:'
        get_schedule['schedule']['users'].each do |user|
          if user['summary'] == @on_call_user
            puts "  * #{user['summary']} (On-Call until #{@end_time})"
          else
            puts "  * #{user['summary']}"
          end
        end
      end

      # Lists all active incidents
      # TODO: Call and print appropriate incident data
      desc 'incidents', 'list all incidents'
      def incidents
        response = HTTParty.get(@incident_url, headers: @headers)
        pp response
      end

      # Lists all incidents regardless of status
      # TODO: Call and print appropriate incident data
      desc 'incident!', 'list all incidents regardless of status'
      def incidents!
        response = HTTParty.get(@incident_url, headers: @headers)
        pp response
      end

      # List a specific incident
      # TODO: Call and print specific incident and data
      desc 'incident', 'list specific incident'
      def incident(id)
        response = HTTParty.get(@incident_url, headers: @headers)
        pp response
      end

      private

      def file_check(file)
        if file.nil?
          false
        else
          File.file?(file)
        end
      end
    end
  end
end
