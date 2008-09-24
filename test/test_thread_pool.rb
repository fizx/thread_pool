require "test/unit"
require "timeout"
require File.dirname(__FILE__) + "/../lib/thread_pool"

class TestThreadPool < Test::Unit::TestCase
  THREADS = 10
  
  def setup
    @pool = ThreadPool.new(THREADS)
  end
  
  def teardown
    @pool.close
  end
  
  def test_creation
    #implicit
  end
  
  def test_pool_size
    assert_equal THREADS, @pool.size 
  end
  
  def test_waiting
    n = 50
    n.times {
      @pool.execute { sleep 10 }
    }
    sleep 0.01
    assert_equal n - THREADS, @pool.waiting
  end
  
  def test_execution
    Timeout::timeout(1) do
      n = 50
      @foo = []
      n.times {
        @pool.execute { @foo << "hi" }
      }
      @pool.join
      assert_equal n, @foo.length
    end
  end
end