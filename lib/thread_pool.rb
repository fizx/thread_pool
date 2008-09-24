# Hooray 
class ThreadPool
  class Executor
    attr_reader :active
    
    def initialize(queue)
      @thread = Thread.new do
        loop do
          if block = queue.shift
            @active = true
            block.call
          else
            @active = false
            sleep 0.01
          end
        end
      end
    end
    
    def close
      @thread.exit
    end
  end
  
  # Initialize with number of threads to run
  def initialize(count)
    @executors = []
    @queue = []
    @count = count    
    count.times { @executors << Executor.new(@queue) }
  end
  
  # Runs the block at some time in the near future
  def execute(&block)
    @queue << block 
  end
  
  # Size of the task queue
  def waiting
    @queue.size
  end
    
  # Size of the thread pool
  def size
    @count
  end
  
  # Kills all threads
  def close
    @executors.each {|e| e.close }
  end
  
  # Sleeps and blocks until the task queue is finished executing
  def join
    sleep 0.01 until @queue.empty? && @executors.all?{|e| !e.active}
  end
end