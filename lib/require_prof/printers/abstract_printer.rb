module RequireProf
  class AbstractPrinter

    def initialize(result)
      @result = result
    end

    def print(output = STDOUT, options = {})
      @output = output
      @option = options
      print_result
    end

    private

    def precision
      @option[:precision] || 2
    end

  end
end
