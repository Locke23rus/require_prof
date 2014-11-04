require 'minitest/autorun'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'examples')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'require_prof'

describe RequireProf do

  describe '.profile' do
    before do
      @result = RequireProf.profile do
        require 'a'
        require 'g'
      end

      # RequireProf.start
      # require 'a'
      # RequireProf.pause
      # require 'mail'
      # RequireProf.resume
      # require 'g'
      # @result = RequireProf.stop

      @delta = 3
    end

    it 'returns call graph' do
      @result.size.must_equal 2
      @result[0][:name].must_equal 'a'
      @result[0][:time].must_be_close_to 10, @delta
      @result[0][:total_time].must_be_close_to 60, @delta
      @result[0][:deps].size.must_equal 2
      @result[0][:deps][0][:name].must_equal 'b'
      @result[0][:deps][0][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:total_time].must_be_close_to 50, @delta
      @result[0][:deps][0][:deps][0][:name].must_equal 'c'
      @result[0][:deps][0][:deps][0][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][0][:total_time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][0][:deps].must_equal []
      @result[0][:deps][0][:deps][1][:name].must_equal 'd'
      @result[0][:deps][0][:deps][1][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:total_time].must_be_close_to 30, @delta
      @result[0][:deps][0][:deps][1][:deps].size.must_equal 2
      @result[0][:deps][0][:deps][1][:deps][0][:name].must_equal 'e'
      @result[0][:deps][0][:deps][1][:deps][0][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:deps][0][:total_time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:deps][0][:deps].must_equal []
      @result[0][:deps][0][:deps][1][:deps][1][:name].must_equal 'f'
      @result[0][:deps][0][:deps][1][:deps][1][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:deps][1][:total_time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:deps][1][:deps].must_equal []
      @result[0][:deps][1][:name].must_equal 'd'
      @result[0][:deps][1][:time].must_be_close_to 0, @delta
      @result[0][:deps][1][:total_time].must_be_close_to 0, @delta
      @result[0][:deps][1][:deps].must_equal []
      @result[1][:name].must_equal 'g'
      @result[1][:time].must_be_close_to 10, @delta
      @result[1][:total_time].must_be_close_to 10, @delta
      @result[1][:deps].must_equal []
    end

  end
end
