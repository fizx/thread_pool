Gem::Specification.new do |s|
  s.name     = "thread_pool"
  s.version  = "0.3.0"
  s.date     = "2008-09-24"
  s.summary  = "A ruby thread pool"
  s.email    = "kyle@kylemaxwell.com"
  s.homepage = "http://github.com/fizx/thread_pool"
  s.description = "A simple thread pool"
  s.has_rdoc = true
  s.authors  = ["Kyle Maxwell"]
  s.files    = %w[
    README CHANGELOG lib/thread_pool.rb
    ]
  s.test_files = %w[test/test_thread_pool.rb]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = %w[CHANGELOG README]
end