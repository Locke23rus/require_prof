require 'require_prof/profile'
require 'require_prof/printers/tree_printer'

# TODO: Add text output
# TODO: Add option :threshold - only text format
# TODO: Add option :order - only text format
# TODO: Comment on https://twitter.com/schneems/status/531820584779264002

module RequireProf

  def self.start
    ensure_not_running!
    @profile = Profile.new
    @profile.start
  end

  def self.pause
    ensure_running!
    @profile.pause
  end

  def self.running?
    if defined?(@profile) and @profile
      @profile.running?
    else
      false
    end
  end

  def self.paused?
    if defined?(@profile) and @profile
      @profile.paused?
    else
      false
    end
  end

  def self.resume
    ensure_running!
    @profile.resume
  end

  def self.stop
    ensure_running!
    result = @profile.stop
    @profile = nil
    result
  end

  def self.profile(&block)
    unless block_given?
      raise(ArgumentError, 'A block must be provided to the profile');
    end
    ensure_not_running!

    start
    yield
    stop
  end

  def self.require(name)
    if running? && !paused?
      parent = @profile.stack.last
      node = { name: name, deps: [], time: 0.0, total_time: 0.0}
      parent[:deps] << node
      @profile.stack.push(node)
      begin
        before = Time.now.to_f
        original_require name
      ensure
        @profile.stack.pop
        after = Time.now.to_f
      end
      node[:time] = (after - before) * 1000
      node[:total_time] = node[:time]
    else
      original_require name
    end
  end

  private

  def self.ensure_running!
    raise(RuntimeError, 'RequireProf.start was not yet called') unless running?
  end

  def self.ensure_not_running!
    raise(RuntimeError, 'RequireProf.start was already called') if running?
  end
end
