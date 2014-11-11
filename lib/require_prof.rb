require 'require_prof/profile'
require 'require_prof/printers/tree_printer'

# TODO: Add text output
# TODO: Add option :threshold - only text format
# TODO: Add option :order - only text format
# TODO: Comment on https://twitter.com/schneems/status/531820584779264002
# TODO: Measure memory footprint


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
      @profile.require(name)
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
