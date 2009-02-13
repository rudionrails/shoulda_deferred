module Rudionrails
  module ShouldaDeferred
    VERSION = "0.0.1"
  end
end

if defined? ::Thoughtbot::Shoulda
  require File.dirname(__FILE__) + '/lib/shoulda_deferred'
else
  $stderr.puts "Skipping ShouldaDeferred plugin. `gem install thoughtbot-shoulda` and try again."
end
