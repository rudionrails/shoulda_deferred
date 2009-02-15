require 'rubygems'
require 'active_support'
require 'active_support/test_case'

# gem install redgreen for colored test output
begin require 'redgreen'; rescue LoadError; end

begin
  require 'shoulda'
rescue LoadError
  $stderr.puts "Unable to run ShouldaDeferred tests. `gem install thoughtbot-shoulda` and try again."
else
  require File.dirname(__FILE__) + "/../lib/shoulda_deferred"
end
