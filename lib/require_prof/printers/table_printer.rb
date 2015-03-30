# encoding: utf-8

require 'set'
require 'require_prof/printers/abstract_printer'
require 'text-table'


module RequireProf
  class TablePrinter < AbstractPrinter
    SORTABLE_COLUMNS = %w(time memory)

    private

    def print_result
      process_result
      print_table
    end

    def process_result
      @processed_nodes = Set.new
      @rows = []
      process_nodes @result.children
    end

    def print_table
      @output << Text::Table.new(head: ["name", "time (ms)", "memory (kb)"], rows: sorted_rows).to_s
    end

    def process_nodes(nodes)
      nodes.each do |node|
        unless @processed_nodes.include?(node.name)
          @processed_nodes.add node.name
          @rows << [node.name, node.time.round(precision), node.memory]
          process_nodes node.children
        end
      end
    end

    def sorted_rows
      column = SORTABLE_COLUMNS.index(sort) + 1
      @rows.select { |i| i[column] > threshold}.sort_by { |i| i[column] }.reverse
    end

    def sort
      column = @options[:sort].to_s
      SORTABLE_COLUMNS.include?(column) ? column : 'time'
    end

    def threshold
      @options[:threshold] || 0.0
    end

  end
end
