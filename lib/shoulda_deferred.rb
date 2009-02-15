module Rudionrails
  module ShouldaDeferred

    KLASS_SCOPE = defined?(Thoughtbot) && defined?(Thoughtbot::Shoulda) ? Thoughtbot::Shoulda : Shoulda
    
    # This lets you defer tests. 
    # You can either use:
    # * xshould to defer any should block
    # * xcontext to defer a whole conext block
    # * xshould_... to defer any shoulda macro that does not take a block, 
    #   like should_respond_with(:success) => xshould_respond_with(:success)

    def xshould ( name, &block ); send(:should_eventually, name, &block ); end
    
    def method_missing_with_xshould ( method, *args, &block )
      # don't do it if it's not starting with xshould
      unless method.to_s.index('xshould') == 0
        return method_missing_without_xshould(method, *args, &block) 
      end
      
      name = method.to_s.sub('xshould_', '').split('_') + args
      xshould name.join(' '), &block
    end
    alias_method_chain :method_missing, :xshould
    
    # xcontext is used just like a regular context block
    def xcontext (name, &block )
      xcontext = DeferredContext.new(name, self, &block)
      xcontext.build
    end
    
    class DeferredContext < KLASS_SCOPE::Context # :nodoc:
      def should ( name, options = {}, &blk )
        self.should_eventuallys << { :name => name }
      end
      
      def context ( name, &blk )
        self.subcontexts << DeferredContext.new(name, self, &blk)
      end
      alias_method :xcontext, :context
      
     def method_missing_with_xshould ( method, *args, &block )
        
     end
     alias_method_chain :method_missing, :xshould
      
    end
    
  end
end

Test::Unit::TestCase.extend( Rudionrails::ShouldaDeferred )
