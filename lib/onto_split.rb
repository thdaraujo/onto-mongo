module OntoSplit
  def self.split(sparql)
    where = sparql.downcase.split("where")

    w = where[1].delete '{' '}'
    triples = w.split(/[.;\n]/)

    t_arr = Array.new
    triples.each do |t|
      if !(t.empty?) || t.length > 3
        t_arr << Triple.new(t.split)
      end
    end

    return t_arr
  end
end
