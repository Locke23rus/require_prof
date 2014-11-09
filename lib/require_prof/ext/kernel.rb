module ::Kernel
  alias_method :require_without_prof, :require

  def require_with_prof(name)
    if RequireProf.running? && !RequireProf.paused?
      RequireProf.add_trace caller.first, name
    else
      require_without_prof name
    end
  end

end
