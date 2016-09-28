class Triple
  def initialize(list)
      @subject=list[0]
      @predicate=list[1]
      @object=list[2]
   end

   def subject
     @subject
   end

   def predicate
     @predicate
   end

   def object
     @object
   end

   def json
     return { subject: @subject, property: @predicate, object: @object}
   end
end
