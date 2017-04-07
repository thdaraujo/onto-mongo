require 'sparql'
require 'sxp'

class OntoQuery
  attr_accessor :sxp, :raw_sxp

  def initialize(sparql)
    @raw_sxp = SPARQL.parse(sparql).to_sxp
    @sxp     = SXP::Reader::SPARQL.read(@raw_sxp)
  end

  def prefixes
    sxp.second.to_h if sxp.include?(:prefix) && sxp.second.present?
  end

  def body
    sxp.last
  end

  def filter
    return nil unless body.present?
    ops = {
      :== => :eq,  :!= => :ne,
      :>= => :gte, :>  => :$gt,
      :<  => :lt,  :<= => :lte
    }

    op, *args = body[body.index(:filter) + 1]
    var_names = args.map(&:name)

    { ops[op] => var_names }
  end

  def bgp
    return nil unless body.present?
    body.last
  end

  def triples
      return nil unless bgp.present?
      if bgp.first == :triple
        _, *tail = bgp
        [Triple.new(tail)]
      else
        bgp.select{|e| e.first == :triple }.
            map{|e|
              _, *tail = e
              Triple.new(tail)
            }
      end

  end

  def project
    return nil unless sxp.include?(:project)
    sxp[sxp.index(:project) + 1].map(&:name)
  end

  def group
  end

  def sort
  end

  private

end

# ruby mongoid:
# User.collection.aggregate([project, group, sort])
