require 'require_prof/ext/kernel'
require 'require_prof/memory_sampler'
require 'require_prof/require_tree'

module RequireProf
  class Profile

    def initialize
      @running = false
      @paused = false
      @root = RequireTree.new('.')
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
      @root
    end

    def require(name)
      node = RequireTree.new(name)
      @stack.last << node
      @stack << node
      begin
        time_before = Time.now.to_f
        if MemorySampler.available?
          memory_before = MemorySampler.memory_usage
          overhead_time_before = Time.now.to_f - time_before
        end
        original_require name
      ensure
        @stack.pop
        if MemorySampler.available?
          tmp_time = Time.now.to_f
          memory_after = MemorySampler.memory_usage
          overhead_time_after = Time.now.to_f - tmp_time
        end
        time_after = Time.now.to_f
      end
      node.total_time = (time_after - time_before) * 1000
      if MemorySampler.available?
        node.total_memory = memory_after - memory_before
        node.overhead_time = (overhead_time_before + overhead_time_after) * 1000
      end
    end

    private

    def install_hook
      ::Kernel.send(:define_method, :require) { |file| RequireProf.require file }
    end

    def remove_hook
      ::Kernel.send :alias_method, :require, :original_require
    end

    def post_process
      @root.process_time
      @root.process_memory
    end

  end
end
