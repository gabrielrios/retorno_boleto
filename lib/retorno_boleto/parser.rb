module FixedWidthParser

  def parse_lines(lines, &block)
    fixed_width_layout(&block)

    lines.map { |line| load_line(line)  }
  end

  def fixed_width_layout(&block)
    yield self
  end

  def parse_field(field, range, block = nil)
    @parse_values = [] if @parse_values.nil?
    @parse_values << [field, range, block]
  end

  def field(field, range, block=nil)
    parse_field(field,range,block)
  end

  def load_line(line)
    this = {}
    begin
      @parse_values.each do |params|
        if params[2] # it's block
          this[params[0]] = params[2].call(line[params[1]])
        else
          this[params[0]] = line[params[1]].to_s.strip
        end
      end
      this
    rescue
      raise "ParseLine::MalformedLayoutOrLine: '#{line.to_s.strip}', size: #{line.to_s.size}"
    end
  end
end
