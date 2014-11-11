require 'require_prof/ext/kernel'

module RequireProf
  class Profile

    def initialize
      @running = false
      @paused = false
      @root = {name: '.', deps: [], time: 0.0, total_time: 0.0}
      @stack = [@root]
    end

    def running?
      @running
    end

    def paused?
      @paused
    end

    def start
      install_hook
      @running = true
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
      @root[:deps]
    end

    def require(name)
      parent = @stack.last
      node = { name: name, deps: [], time: 0.0, total_time: 0.0}
      parent[:deps] << node
      @stack.push(node)
      begin
        time_before = Time.now.to_f
        original_require name
      ensure
        @stack.pop
        time_after = Time.now.to_f
      end
      node[:total_time] = (time_after - time_before) * 1000
    end

    private

    def install_hook
      ::Kernel.send(:define_method, :require) { |file| RequireProf.require file }
    end

    def remove_hook
      ::Kernel.send :alias_method, :require, :original_require
    end

    def post_process
      process_time(@root[:deps])
    end

    def process_time(deps)
      deps.each do |dep|
        dep[:time] = dep[:total_time] - dep[:deps].map { |d| d[:total_time] }.reduce(:+).to_f
        process_time dep[:deps] unless dep[:deps].empty?
      end
    end

  end
end
