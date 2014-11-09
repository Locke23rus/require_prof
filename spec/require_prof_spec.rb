require 'minitest/autorun'

$LOAD_PATH << File.join(File.dirname(__FILE__), 'fixtures')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'require_prof'

describe RequireProf do

  describe '.profile' do
    before do
      @result = RequireProf.profile do
        require 'big_tree/a'
        require 'big_tree/g'
      end
      @delta = 3
    end

    it 'returns require graph' do
      @result.size.must_equal 2
      @result[0][:name].must_equal 'big_tree/a'
      @result[0][:time].must_be_close_to 10, @delta
      @result[0][:total_time].must_be_close_to 60, @delta
      @result[0][:deps].size.must_equal 2
      @result[0][:deps][0][:name].must_equal 'big_tree/b'
      @result[0][:deps][0][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:total_time].must_be_close_to 50, @delta
      @result[0][:deps][0][:deps][0][:name].must_equal 'big_tree/c'
      @result[0][:deps][0][:deps][0][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][0][:total_time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][0][:deps].must_equal []
      @result[0][:deps][0][:deps][1][:name].must_equal 'big_tree/d'
      @result[0][:deps][0][:deps][1][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:total_time].must_be_close_to 30, @delta
      @result[0][:deps][0][:deps][1][:deps].size.must_equal 2
      @result[0][:deps][0][:deps][1][:deps][0][:name].must_equal 'big_tree/e'
      @result[0][:deps][0][:deps][1][:deps][0][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:deps][0][:total_time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:deps][0][:deps].must_equal []
      @result[0][:deps][0][:deps][1][:deps][1][:name].must_equal 'big_tree/f'
      @result[0][:deps][0][:deps][1][:deps][1][:time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:deps][1][:total_time].must_be_close_to 10, @delta
      @result[0][:deps][0][:deps][1][:deps][1][:deps].must_equal []
      @result[0][:deps][1][:name].must_equal 'big_tree/d'
      @result[0][:deps][1][:time].must_be_close_to 0, @delta
      @result[0][:deps][1][:total_time].must_be_close_to 0, @delta
      @result[0][:deps][1][:deps].must_equal []
      @result[1][:name].must_equal 'big_tree/g'
      @result[1][:time].must_be_close_to 10, @delta
      @result[1][:total_time].must_be_close_to 10, @delta
      @result[1][:deps].must_equal []
    end
  end

  describe 'when used start/stop + pause/resume' do
    before do
      RequireProf.start
      require 'big_tree/e'
      RequireProf.pause
      require 'big_tree/f'
      RequireProf.resume
      require 'big_tree/g'
      @result = RequireProf.stop
    end

    it 'returns require graph with skipped paused requires' do
      @result.size.must_equal 2
      @result[0][:name].must_equal 'big_tree/e'
      @result[0][:deps].must_equal []
      @result[1][:name].must_equal 'big_tree/g'
      @result[1][:deps].must_equal []
    end
  end
end
