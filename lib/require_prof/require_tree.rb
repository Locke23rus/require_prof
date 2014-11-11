
module RequireProf
  class RequireTree

    attr_reader :name
    attr_accessor :time, :total_time

    def initialize(name)
      @name = name
      @children = {}
      @time = 0.0
      @total_time = 0.0
    end

    def <<(tree)
      @children[tree.name] ||= tree
    end

    def [](name)
      @children[name]
    end

    def children
      @children.values
    end

    def process_time
      children.map(&:process_time)
      @time = total_time - children.map(&:total_time).reduce(:+).to_f
    end

    def to_h
      {
        name: name,
        children: children.map(&:to_h),
        time: time,
        total_time: total_time
      }
    end

  end
end
