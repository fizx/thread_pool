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
  
  class A
    def initialize(i)
      @i = i
    end
    attr_reader :i
  end
  
  def test_context
    @foo = []
    @bar = (0...5).to_a
    while c = @bar.shift
      @pool.execute { @foo << c }
    end
    @pool.join
    assert_equal [nil] * 5, @foo
    
    @foo = []
    @bar = (0...5).to_a
    while c = @bar.shift
      @pool.execute(c) {|n| @foo << n }
    end
    @pool.join
    assert_equal (0...5).to_a, @foo
  end
  
  def test_queue_limit
    n = 50
    @foo = 0
    @pool.queue_limit = 1
    begin
      Timeout::timeout(0.2) do
        n.times {
          @pool.execute {  sleep 1 }
          @foo += 1
        }
      end 
    rescue Timeout::Error
      assert_equal @pool.queue_limit + @pool.size, @foo
    else
      assert false
    end
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
  
  def test_synchronous_execute
    Timeout::timeout(1) do
      @foo = false
      @pool.execute { sleep 0.01; @foo = true }
      assert !@foo
    
      @foo = false
      @pool.synchronous_execute { sleep 0.01; @foo = true }
      assert @foo
    end
  end
end