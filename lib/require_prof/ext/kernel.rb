module ::Kernel
  alias_method :require_prof_orig, :require

  def require_prof(name)
    if RequireProf.running? && !RequireProf.paused?
      RequireProf.add_trace caller.first, name
    else
      require_prof_orig name
    end
  end

end
