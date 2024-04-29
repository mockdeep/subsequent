# frozen_string_literal: true

require "active_support/all"
require "http"
require "io/console"
require "yaml"

module Subsequent
  class Error < StandardError; end
end

require_relative "subsequent/version"
require_relative "subsequent/colors"
require_relative "subsequent/actions"
require_relative "subsequent/models"
require_relative "subsequent/trello_client"
