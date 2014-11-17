# encoding: utf-8

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
        info = "#{node.name} (#{node.total_time.round(precision)} ms, #{node.total_memory.round} kb)\n"
        if i == last
          @output << "#{prefix}└── #{info}"
          print_trees(node.children, prefix + '    ')
        else
          @output << "#{prefix}├── #{info}"
          print_trees(node.children, prefix + '│   ')
        end
      end
    end

  end
end
