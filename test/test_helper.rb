$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'on_ramp'

require 'minitest/autorun'
require 'active_support'
require 'active_support/testing/assertions'

module OnRamp
  class TestCase < Minitest::Test
    include ActiveSupport::Testing::Assertions
  end
end
