require 'rubygems'
require 'active_support'
require 'active_support/test_case'

# gem install redgreen for colored test output
begin require 'redgreen'; rescue LoadError; end

require File.dirname(__FILE__) + "/../lib/shoulda_deferred"
