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
end
