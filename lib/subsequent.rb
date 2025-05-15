# frozen_string_literal: true

require "active_support/all"
require "http"
require "io/console"
require "yaml"

# top-level module for the gem
module Subsequent; end

class Subsequent::Error < StandardError; end

require_relative "subsequent/configuration"
require_relative "subsequent/configuration/helpers"
require_relative "subsequent/display_helpers"

require_relative "subsequent/actions"
require_relative "subsequent/commands"
require_relative "subsequent/filters"
require_relative "subsequent/mode"
require_relative "subsequent/models"
require_relative "subsequent/sort"
require_relative "subsequent/state"
require_relative "subsequent/trello_client"
require_relative "subsequent/version"
