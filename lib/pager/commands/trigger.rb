#!/usr/bin/env ruby
# frozen_string_literal: true
# -*- coding: UTF-8 -*-

require 'httparty'
require 'thor'

module PAGER
  module COMMANDS
    class Trigger < Thor

      def initialize(*args)
        super
        if File.file?(File.join(__dir__, '../../../config/pager.local.yml'))
          config_file = "#{File.join(__dir__, '../../../config/pager.local.yml')}"
        else
          config_file = "#{File.join(__dir__, '../../../config/pager.yml')}"
        end
        @config = YAML.load_file(config_file) if File.file?(config_file)
        @base_url = 'https://api.pagerduty.com'
        if @config['pager']['token'].nil? && ENV['PAGER_TOKEN'].nil?
          raise "You need to setup a config file or PAGER_TOKEN environment variable"
        elsif @config['pager']['service'].nil? && ENV['PAGER_SERVICE'].nil?
          raise "You need to setup a config file or PAGER_SERVICE environment variable"
        else
          @token = @config['pager']['token'] || ENV['PAGER_TOKEN']
          @service_key = @config['pager']['service'] || ENV['PAGER_SERVICE']
        end
        @endpoint = 'https://events.pagerduty.com/generic/2010-04-15/create_event.json'
        @headers = {
          'Authorization' => "Token token=#{@token}"
        }

        data = {
          service_key: @service_key,
          event_type: 'trigger',
          description: "#{args[0]}"
        }
        puts "My service id is: #{@service_key}"
        puts "THESE ARE AAAARRRRGGGSSS"
        puts args[0]
        response = HTTParty.get(@endpoint, body: data, headers: @headers)
        puts "Successfully triggered #{response['incident_key']}" if response.code == '200'
        puts "Something went wrong, received #{response.code}" unless response.code == '200'
      end
    end
  end
end
