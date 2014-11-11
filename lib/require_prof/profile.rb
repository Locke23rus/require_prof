require 'require_prof/ext/kernel'
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
      parent = @stack.last
      node = RequireTree.new(name)
      parent << node
      @stack << node
      begin
        time_before = Time.now.to_f
        original_require name
      ensure
        @stack.pop
        time_after = Time.now.to_f
      end
      node.total_time = (time_after - time_before) * 1000
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
    end

  end
end
