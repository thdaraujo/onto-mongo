require 'test_helper'

class ResearcherTest < ActiveSupport::TestCase
  test "researcher sparl query" do
    sparql = %(
      PREFIX foaf:   <http://xmlns.com/foaf/0.1/>
      SELECT ?name
      WHERE
        { ?x foaf:name 'Eliana da Silva Pereira' }
    )

    result = Researcher.query(sparql)
    assert result.present? == true
  end
end
