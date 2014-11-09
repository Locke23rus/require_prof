require 'require_prof/ext/kernel'

module RequireProf
  class Profile

    def initialize
      @running = false
      @paused = false
      @result = []
      @trace = []
    end

    def running?
      @running
    end

    def paused?
      @paused
    end

    def start
      @running = true
      install_hook
    end

    def install_hook
      ::Kernel.send :alias_method, :require, :require_with_prof
    end

    def remove_hook
      ::Kernel.send :alias_method, :require, :require_without_prof
    end

    def pause
      @paused = true
    end

    def resume
      @paused = false
    end

    def stop
      remove_hook
      @running = false
      post_process
      @result
    end

    def add_trace(caller, name)
      @trace << [caller, name, benchmark(name)]
    end

    private

    def post_process
      process_trace
      process_time(@result)
    end

    def process_trace
      @trace.reverse.each do |from, name, time|
        if from.end_with?("<main>'") || from.end_with?("irb_binding'")
          @result.unshift({ name: name, time: time, total_time: time, deps: [] })
        else
          caller = find_caller(from, @result)
          caller[:deps].unshift({ name: name, time: time, total_time: time, deps: [] })
        end
      end
    end

    def process_time(deps)
      deps.each do |dep|
        unless dep[:deps].empty?
          dep[:time] = dep[:total_time] - dep[:deps].map { |d| d[:total_time] }.reduce(:+)
          process_time dep[:deps]
        end
      end
    end

    def find_caller(from, deps)
      return deps.first if from.include?("/#{deps.first[:name]}.rb")
      find_caller(from, deps.first[:deps])
    end

    def benchmark(name)
      start = Time.now.to_f
      require_without_prof(name) rescue nil
      (Time.now.to_f - start) * 1000 # ms
    end

  end
end
