class Triple
  attr_accessor :subject, :predicate, :object
  def initialize(list)
      @subject = list[0]
      @predicate = list[1]
      @object = list[2]
   end

   def json
     return { subject: @subject, property: @predicate, object: @object}
   end
end
