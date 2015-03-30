module RequireProf
  class AbstractPrinter

    def initialize(result)
      @result = result
    end

    def print(options = {})
      @options = options
      @output = options.fetch(:output, STDOUT)
      print_result
    end

    private

    def precision
      @options[:precision] || 2
    end

  end
end
