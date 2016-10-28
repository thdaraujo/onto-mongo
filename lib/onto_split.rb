require 'sparql'

module OntoSplit
  def self.split(sparql)
    t_arr = Array.new
    sse = SPARQL.parse(sparql).to_sse

    triples = sse.scan /\(triple.*?\)/

    triples.each do |triple|
      triple = triple.delete '(' ')'
      triple = triple.gsub('triple','')
      terms = triple.split(/\s(?=(?:[^"]|"[^"]*")*$)/)
      terms = terms.reject(&:empty?).map{|t| t.delete '"' }
      t_arr << Triple.new(terms)
    end
    return t_arr
  end

end
