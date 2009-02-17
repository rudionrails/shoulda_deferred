module Rudionrails
  module ShouldaDeferred

    KLASS_SCOPE = defined?(::Thoughtbot) && defined?(::Thoughtbot::Shoulda) ? ::Thoughtbot::Shoulda : ::Shoulda
    
    # This lets you defer tests. 
    # You can either use:
    # * xshould to defer any should block
    # * xcontext to defer a whole conext block
    # * xshould_... to defer any shoulda macro that does not take a block, 
    #   like should_respond_with(:success) => xshould_respond_with(:success)

    def xshould ( name, &blk ); send(:should_eventually, name, &blk ); end
    
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
      if KLASS_SCOPE.current_context
        KLASS_SCOPE.current_context.context(name, &blk)
      else
        xcontext = DeferredContext.new(name, self, &blk)
        xcontext.build
      end
    end

    class KLASS_SCOPE::Context
      def xshould ( name, &blk ); send(:should_eventually, name, &blk ); end
      
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
    
    class DeferredContext < KLASS_SCOPE::Context # :nodoc:
      alias_method :should, :xshould
      
      def context ( name, &blk )
        self.subcontexts << DeferredContext.new(name, self, &blk)
      end   
    end
    
  end
end

Test::Unit::TestCase.extend( Rudionrails::ShouldaDeferred )
