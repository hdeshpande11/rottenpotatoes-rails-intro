class Movie < ActiveRecord::Base
 
 def movieclass_params
     
    params.require(:movie).permit(:title, :rating, :description, :release_date)
 end
 
 def self.get_ratings
    collect_ratings = []
    self.select("rating").uniq.each {|element| collect_ratings.push(element.rating) }
    collect_ratings
 end
        
end
