module Rudionrails
  module ShouldaDeferred
    VERSION = "0.0.2"
  end
end

begin
  require 'shoulda'
  raise("could not find shoulda") unless defined?(Shoulda) || defined?(Thoughtbot) && defined?(Thoughtbot::Shoulda)
rescue
  $stderr.puts "Skipping ShouldaDeferred plugin. `gem install thoughtbot-shoulda` and try again."
else
  require File.dirname(__FILE__) + '/lib/shoulda_deferred'
end
