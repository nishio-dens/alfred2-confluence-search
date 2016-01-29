# coding: utf-8

require 'rubygems' unless defined? Gem
require_relative "bundle/bundler/setup"
require 'keychain'
require_relative 'alfred2_workflow'

# Settings
KEYCHAIN_KEY="alfred2-confluence-search"
confluence_info = Keychain.internet_passwords.where(comment: KEYCHAIN_KEY).first

# Methods
Alfred2Workflow.new.execute(confluence_info)
