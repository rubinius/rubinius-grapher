require "rubinius/grapher/version"

module Rubinius
  module Grapher
    class AsciiGraph
      attr_reader :title

      def initialize(x, y, title, data)
        @x = x
        @y = y
        @title = title
        @data = data
      end

      def plot
        draw_axes
        draw_title
        draw_data

        self
      end

      def canvas
        @canvas ||= (@y).times.to_a.map { Array.new @x, " " }
      end

      def draw_axes
        @x_axis = @y - 2
        @y_axis = 4

        (1..@y-3).each { |i| canvas[i][@y_axis] = "|" }
        (2..@x-2).each { |i| canvas[@x_axis][i] = "-" }

        canvas[@x_axis][@y_axis - 1] = "-"
        canvas[@x_axis][@y_axis] = "+"
        canvas[@x_axis + 1][@y_axis] = "|"
      end

      def draw_title
        canvas[@y] = @title.center(@x).split("")
      end

      def draw_data
        min = @data.min
        max = @data.max

        graph_width = @x - @x_axis - 3
        width = @data.size

        if width > graph_width
          columns = (0..graph_width).to_a
        else
          r = width.to_f / graph_width
          columns = Array.new(graph_width) { |i| (i * r).to_i }
        end

        graph_y = @y - 3
        graph_height = @y - 5
        height = max + 1 - min
        r = graph_height.to_f / height

        columns.each do |c|
          y = graph_y - (@data[c] - min) * r
          x = c + @y_axis + 2

          @canvas[y][x] = "."
        end
      end

      def to_s
        canvas.map { |r| r.join << "\n" }.join
      end
    end

    def self.graph
      filename = ARGV.shift

      contents = File.readlines filename
      metrics = contents.shift.chomp.split ", "

      rows = contents.map { |x| x.chomp.split.map { |n| n.to_i } }

      data = { }

      metrics.each_with_index do |m, i|
        data[m] = rows.map { |r| r[i] }
      end

      width = Rubinius::TERMINAL_WIDTH
      height = 12

      graphs = data.map do |t, d|
        AsciiGraph.new width, height, t, d
      end

      graphs.sort! { |a, b| a.title <=> b.title }

      graphs.each { |g| puts g.plot.to_s }
    end
  end
end
