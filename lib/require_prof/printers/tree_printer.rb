require 'require_prof/printers/abstract_printer'

module RequireProf
  class TreePrinter < AbstractPrinter

    private

    def print_result
      @output << ".\n"
      print_tree(@result)
    end

    def print_tree(deps, prefix = '')
      last = deps.size - 1
      deps.each_with_index do |dep, i|
        if i == last
          @output << "#{prefix}└── #{dep[:name]} (#{dep[:time].round(precision)} ms)\n"
          print_tree(dep[:deps], prefix + '    ')
        else
          @output << "#{prefix}├── #{dep[:name]} (#{dep[:time].round(precision)} ms)\n"
          print_tree(dep[:deps], prefix + '│   ')
        end
      end
    end

  end
end
