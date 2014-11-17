module RequireProf
  class MemorySampler

    def self.available?
      return @available if defined?(@available)
      @available = defined?(JRuby) || platform =~ /linux|darwin|freebsd|solaris/
      unless @available
        STDERR.puts "WARNING: Unsupported platform for getting memory '#{platform}'"
      end
      @available
    end

    def self.sampler
      return @sampler if defined?(@sampler)

      @sampler = if defined? JRuby
                   JavaHeapSampler.new
                 elsif platform =~ /linux/
                   ProcStatus.new
                   # ShellPS.new('ps -o rsz')
                 elsif platform =~ /darwin9/ # 10.5
                   ShellPS.new('ps -o rsz')
                 elsif platform =~ /darwin1\d+/ # >= 10.6
                   ShellPS.new('ps -o rss')
                 elsif platform =~ /freebsd/
                   ShellPS.new('ps -o rss')
                 elsif platform =~ /solaris/
                   ShellPS.new('/usr/bin/ps -o rss -p')
                 end
    end

    def self.platform
      if RUBY_PLATFORM =~ /java/
        %x[uname -s].downcase
      else
        RUBY_PLATFORM.downcase
      end
    end

    def self.memory_usage
      sampler.memory_usage
    end

    class JavaHeapSampler
      def memory_usage
        raise "Can't sample Java heap unless running in JRuby" unless defined? JRuby
        java.lang.Runtime.getRuntime.totalMemory / 1024.0 rescue 0.0
      end
    end

    class ShellPS
      def initialize(command)
        @command = command
      end

      def memory_usage
        process = $$
        `#{@command} #{process}`.split("\n")[1].to_f rescue 0.0
      end
    end

    class ProcStatus
      def memory_usage
        proc_status = File.open("/proc/#{$$}/status", 'r') { |f| f.read_nonblock(4096).strip }
        if proc_status =~ /RSS:\s*(\d+) kB/i
          $1.to_f
        else
          0.0
        end
      end
    end
  end
end
