require 'require_prof/ext/kernel'

module RequireProf
  class Profile

    attr_reader :stack

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
        unless dep[:deps].empty?
          dep[:time] = dep[:total_time] - dep[:deps].map { |d| d[:total_time] }.reduce(:+)
          process_time dep[:deps]
        end
      end
    end

  end
end
