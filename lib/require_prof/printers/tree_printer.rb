require 'require_prof/printers/abstract_printer'

module RequireProf
  class TreePrinter < AbstractPrinter

    private

    def print_result
      @output << "#{@result.name}\n"
      print_trees(@result.children)
    end

    def print_trees(nodes, prefix = '')
      last = nodes.size - 1
      nodes.each_with_index do |node, i|
        if i == last
          @output << "#{prefix}└── #{node.name} (#{node.time.round(precision)} ms)\n"
          print_trees(node.children, prefix + '    ')
        else
          @output << "#{prefix}├── #{node.name} (#{node.time.round(precision)} ms)\n"
          print_trees(node.children, prefix + '│   ')
        end
      end
    end

  end
end
