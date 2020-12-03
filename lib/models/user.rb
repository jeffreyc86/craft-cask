class User < ActiveRecord::Base

    has_many :reviews
    has_many :orders
    has_many :order_items, through: :orders

    def self.login_a_user
        puts "Welcome Back!"
        puts "Please enter your username."
        userName = gets.chomp
        puts "Please enter your password."
        pass = gets.chomp

        user = User.find_by(username: userName, password: pass)

        if user.nil?
            puts "Sorry, nobody with that username and password combination exists. Please try again."
        else
            user
        end

    end

    # def self.register_a_user
    #     x_var = "condition is not met"
    #     while x_var == "condition is not met"

    #         puts "Please enter your birthdate in the following format: YYYY, MM, DD"
    #         birthday = gets.chomp
    #         bday_sec = Time.new(birthday).to_i

    #     if bday_sec

    #         if #user is 21
    #             x_var = "condition is met" #breaks out of while loop
    #         else 
    #             #some condition 
    #         end 

    #     end 
    # end 

    # def self.register_a_user

    #     puts "Please enter your birthdate in the following format: YYYY, MM, DD"
    #     birthday = gets.chomp
    #     bday_sec = Time.new(birthday).to_i

    #     #we need to figure out how to ensure that the birthdate is entered in the correct format because Time.new() can create
    #     #a time as long as at least a 4 digit integer is included and it also doesn't know to separate the month & day if no commas
    #     #are used

    #     if bday_sec


    #     #calculates age of new user if birthday format is properly inputted 
    #         if (Time.now.to_i - bday_sec).to_f / (365 * 24 * 60 * 60) >= 21.0
    #         puts "Please enter a username."
    #         userName = gets.chomp
    #         puts "Please enter a password."
    #         pass = gets.chomp
            
    #             user = User.find_by(username: userName)
            
    #             if user
    #             puts "Sorry, that username is already taken"
    #             else
    #             # User.create(username: userName, password: pass, age: age)
    #             end
      
    #         else
    #         puts "Sorry, unfortunately you're not old enough yet. Please visit back on your 21st birthday!"
    #         end

    #     else
    #     puts "Sorry, that format was incorrect."
    #     register_a_user
    #     end

    # end

  


        # user = User.find_by(username: userName)

        # if user
        #     puts "Sorry, that username is already taken"
        # else
        #     User.create(username: userName, password: pass, age: age)
    #     # end
    # end


    def order_history
        orders.where(checked_out: true)
    end

    def current_cart
        orders.find_or_create_by(checked_out: false)
    end

    def check_out_current_cart
        puts "Hope you found everything you were looking for, #{self.first_name}. Here are all the items you have in your current cart:"
        self.display_cart
        puts "Your total today is $#{current_cart_total}. Let's check out!"
        self.current_cart.items.each { |item| item.inventory -= 1 }
        self.current_cart.update(checked_out: true)
    end

    def check_out_after_viewing_cart
        puts "Thank for shopping with us, #{self.first_name}. This order has been processed."
        self.current_cart.items.each { |item| item.inventory -= 1 }
        self.current_cart.update(checked_out: true)
    end

    def view_current_cart
        puts "Hope you're finding everything you are looking for, #{self.first_name}. Here are all the items you have in your current cart:"
        self.display_cart
    end

        


    def current_cart_total 
        self.current_cart.items.sum(:price)
    end 

    def display_cart
        self.current_cart.order_items.each do |order_item|
            puts "#{order_item.item.name}"
        end
    end

    def add_item_to_cart(item_inst)
        OrderItem.create(order: self.current_cart, item: item_inst)
    end

    def remove_item_from_cart()
    end


#puts time_stamp.strftime('%s')
#puts time_stamp.to_i
#timestamp = Time.at(628232400)

end