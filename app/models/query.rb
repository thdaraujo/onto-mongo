class Query
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

  # ex: {"neq"=>[:aw1, :aw2]}
  def filter
    return nil unless body.present?
    ops = {
      :==  => "eq", :!= => "neq",
      :>= => "gte", :> => "gt",
      :< => "lt",   :<= => "lte"
    }

    op, *args = body[body.index(:filter) + 1]
    var_names = args.map(&:name)

    { ops[op] => var_names }
  end

  # ex:
  # {
  #  $project: {
  #    "firstName": "$name.first",
  #    "lastName": "$name.last",
  #    "awardName1": "$award1.award",
  #    "awardName2": "$award2.award",
  #    "year": "$award1.year"
  #  }
  #}
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
