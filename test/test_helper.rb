$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "onramp"

require "minitest/autorun"
require "active_support"
require "active_support/testing/assertions"

class Onramp::TestCase < Minitest::Test
  include ActiveSupport::Testing::Assertions
end
