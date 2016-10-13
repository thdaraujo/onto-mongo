require 'sparql'
module OntoSplit
  def self.split(sparql)
    t_arr = Array.new
    sse = SPARQL.parse(sparql).to_sse

    sse.each_line do |line|
      if line.include? "triple"
        line = line.delete '(' ')'
        line = line.gsub('triple','')
        triple = line.split(/\s(?=(?:[^"]|"[^"]*")*$)/)

        t_arr << Triple.new(triple.reject { |c| c.empty? })
      end
    end
    return t_arr
  end

end
