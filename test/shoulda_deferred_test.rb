require File.dirname(__FILE__) + '/test_helper'

class ShouldaDeferredTest < Test::Unit::TestCase

  xshould 'defer the test' do
    flunk "defer"
  end

  xcontext 'a deferred context' do
    should 'do something' do
      flunk "defer nested should block"
    end
    
    context 'with another subcontext' do
      should 'do something awesome' do
        flunk "defer, because of nested context"
      end
    end
    
    xcontext 'with a deferred subcontext' do
      should 'make me happy' do
        flunk "defer, because of nested contexts"
      end
      
      context 'and another one' do
        should 'just work' do
          flunk "defer, because of nested contexts"
        end
      end
    end

    xshould_respond_with :success
    xshould_render_template :index
  end

  context 'a context' do
    xshould 'defer the test' do
      flunk "defer!"
    end

    xcontext 'with a deferred context' do
      should 'do something' do
        flunk 'defer'
      end
    end
  end
    
  xshould_respond_with :success
  xshould_render_template :index

end
