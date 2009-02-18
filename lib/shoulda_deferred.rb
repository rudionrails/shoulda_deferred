require 'shoulda'

# defined Shoulda (pre v2.9.1)
Shoulda = Thoughtbot::Shoulda unless defined?( Shoulda )

module Rudionrails
  module ShouldaDeferred
    
    VERSION = "0.0.5"
    
    # This lets you defer tests. 
    # You can either use:
    # * xshould to defer any should block
    # * xcontext to defer a whole conext block
    # * xshould_... to defer any shoulda macro that does not take a block, 
    #   like should_respond_with(:success) => xshould_respond_with(:success)

    def xshould ( name, options = {}, &blk ); send( :should_eventually, name ); end
    
    # that's for:
    # * xshould_respond_with :success
    # * xshould_...
    def method_missing_with_xshould ( method, *args, &blk )
      # don't do it if it's not starting with xshould
      unless method.to_s.index('xshould') == 0
        return method_missing_without_xshould(method, *args, &blk) 
      end
      
      name = method.to_s.sub('xshould_', '').split('_') + args
      xshould( name.join(' '), &blk )
    end
    alias_method_chain :method_missing, :xshould
    
    # xcontext is used just like a regular context block
    def xcontext (name, &blk )
      if Shoulda.current_context
        Shoulda.current_context.xcontext(name, &blk)
      else
        xcontext = DeferredContext.new(name, self, &blk)
        xcontext.build
      end
    end
    
    # add xshould, xcontext and xshould_... methods to Shoulda Context class
    class Shoulda::Context
      def xshould ( name, options = {}, &blk ); send( :should_eventually, name ); end
      
      def method_missing_with_xshould ( method, *args, &blk )
        # don't do it if it's not starting with xshould
        unless method.to_s.index('xshould') == 0
          return method_missing_without_xshould(method, *args, &blk) 
        end
        
        name = method.to_s.sub('xshould_', '').split('_') + args
        xshould( name.join(' '), &blk )
      end
      alias_method_chain :method_missing, :xshould

      def xcontext ( name, &blk )
        self.subcontexts << DeferredContext.new(name, self, &blk)
      end
    end
    
    # any should and context will be deferred now
    class DeferredContext < Shoulda::Context # :nodoc:
      def setup(&blk); end # just a stub
      def teardown(&blk); end # just a stub
      
      alias_method :should,  :xshould
      alias_method :context, :xcontext
    end
    
  end
end

Test::Unit::TestCase.extend( Rudionrails::ShouldaDeferred )

