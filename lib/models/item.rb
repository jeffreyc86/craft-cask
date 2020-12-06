class Item < ActiveRecord::Base 

    has_many :reviews 
    has_many :order_items 
    has_many :orders, through: :order_items

    # attr_accessor: rating
    
    def rating
        if reviews.count == 0
            "Not Yet Rated"
        else
            "%.1f" % reviews.average(:rating)
        end
    end

    def all_reviews
        reviews.each_with_index do |rev, index|
            puts "#{index + 1}) RATING: #{rev.rating}    REVIEW: #{rev.review}"
        end
    end

end 