require File.dirname(__FILE__) + '/test_helper'

class ShouldaDeferredTest < Test::Unit::TestCase
  
  xshould_change ['my', 'array']
  
  xshould 'defer the test' do
    flunk "defer"
  end
  
  xcontext 'A Deferred context' do
    setup do
      flunk 'defer setup'
    end

    teardown do
      flunk 'defer teardown'
    end
    
    should 'do something' do
      flunk "defer nested should block"
    end
    
    xshould 'defer the test' do
      flunk "defer"
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
      
      xshould 'defer the test' do
        flunk "defer"
      end
      
      context 'and another one' do
        should 'just work' do
          flunk "defer, because of nested contexts"
        end
      end
    end
    
    xshould_change ['my', 'array']
    should_change ['my', 'should',  'array']
  end
  
  context 'A Regular context' do
    xshould 'defer the test' do
      flunk "defer!"
    end
    
    xcontext 'with a Deferred subcontext' do
      setup do
        flunk 'defer setup'
      end

      teardown do
        flunk 'defer teardown'
      end
      
      should 'do something' do
        flunk 'defer'
      end
    end
    
    xshould_change ['my', 'array']
  end
  
end
