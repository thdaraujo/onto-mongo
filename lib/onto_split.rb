module OntoSplit
  def split(sparql)
    where = sparql.downcase.split("where")

    w = where[1].delete '{' '}'
    triples = w.split(/[.;]/)
  end
end
