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
            TTY::Prompt.new.select("Sorry, nobody with that username and password combination exists. Would you like to") do |menu|
                menu.choice "Login again", -> {login_a_user}
                menu.choice "Register", -> {register_a_user}
                menu.choice "Exit", -> {exit_app}
            end
        else
            user
        end
    end

        def self.exit_app
            puts "Peace out homie!"
            exit
        end

    def self.register_a_user
        puts "Please enter your birthdate in the following format: MM/DD/YYYY"
        birthday = gets.chomp

            if birthday.match?(/\A((02\/[0-2]\d)|((01|[0][3-9]|[1][0-2])\/(31|30|[0-2]\d)))\/[12]\d{3}\Z/)

                    split_bday = birthday.split("/").map(&:to_i)
                    
                    bday_sec = Time.new(split_bday[2], split_bday[0], split_bday[1]).to_i
                    age = (Time.now.to_i - bday_sec).to_f / (365 * 24 * 60 * 60)
                    
                    if age >= 21.0
                        puts "Thank you! Now please enter your first name:"
                        firstName = gets.chomp

                            until firstName.match?(/^\A([a-zA-Z]|-){2,30}\Z$/) do
                                puts "Please re-enter your first name using only letters or hyphens."
                                firstName = gets.chomp
                            end 

                        puts "Thank you, #{firstName.capitalize}, what would you like your USERNAME to be?"
                        puts "Enter 5-15 characters using letters, numbers, and underscores(_)"
                        user_name = gets.chomp 

                            until user_name.match?(/^\A\w{5,15}\Z$/) do
                                puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long using only using letters, numbers, and underscores(_)."
                                user_name = gets.chomp
                            end 

                        user = User.find_by(username: user_name)
                          
                            until !User.find_by(username: user_name) do
                                puts "Sorry, that username is already taken. Please enter another username."
                                user_name = gets.chomp
                                    if !user_name.match?(/^\A\w{5,15}\Z$/) 
                                        puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long using only using letters, numbers, and underscores(_)."
                                        user_name = gets.chomp
                                    elsif User.find_by(username: user_name)
                                        puts "Sorry, that username is also taken. Please enter another username."
                                        user_name = gets.chomp
                                    end 
                            end

                        puts "And lastly, please enter your password"
                        pass_word = gets.chomp 
                            until pass_word.match?(/^\A\S{5,15}\Z$/) do
                                puts "Please enter a password 5-15 characters long."
                                pass_word = gets.chomp
                            end
                        puts "Please re-enter your password"
                        pass_word2 = gets.chomp
                 
                            until pass_word == pass_word2 do
                                puts "Sorry the passwords did not match. Please enter a password."
                                pass_word = gets.chomp 
                                until pass_word.match?(/^\A\S{5,15}\Z$/) do
                                    puts "Please enter a password 5-15 characters long."
                                    pass_word = gets.chomp
                                end
                                puts "Please re-enter your password"
                                pass_word2 = gets.chomp
                            end

                        user = User.create(first_name: firstName.capitalize, username: user_name, password: pass_word)
                        user.update(age: age.to_i)
                        user
                    else
                        # puts File.read("lib/wordart/stop_uad.txt")
                        puts "Sorry, please return when you are 21."
                        exit 
                    end
            else
                system 'clear'
                puts "Sorry you entered your birthdate in the incorrect format"
                register_a_user
            end
    end

    def order_history
        orders.where(checked_out: true)
    end

    def current_cart
        orders.find_or_create_by(checked_out: false)
    end

    def check_out_current_cart

        destroy_all_order_items_if_sold_out
        puts "Hope you found everything you were looking for, #{self.first_name}. Here are all the items you have in your current cart:"
        display_cart
        
        current_cart.items.each { |item| item.update(inventory: item.inventory - 1) }
        binding.pry
        puts "Your total today is $#{current_cart_total}. Let's check out!"
        current_cart.update(checked_out: true)
    end

    def check_out_after_viewing_cart
        puts "Thank for shopping with us, #{self.first_name}. This order has been processed."
        self.current_cart.items.each { |item| item.update(inventory: item.inventory - 1) }
        self.current_cart.update(checked_out: true)
    end

    def view_current_cart
        #cool banner?
        destroy_all_order_items_if_sold_out
        puts "Hope you're finding everything you are looking for, #{self.first_name}. Here are all the items currently in your cart:"
        self.display_cart
    end

    def destroy_all_order_items_if_sold_out
        sold_out_items = current_cart.items.where(inventory: 0)
        sold_out_items.each do |item|
            OrderItem.find_by(order_id: current_cart.id, item_id: item.id).destroy
            puts "Sorry, unfortunately #{item.name} is currently out of stock. It has been removed."
        end
    end

    # def remove_from_current_cart(item_inst) 
    #     #takes in id and removes item from cart of user 
    #     user.current_cart.orderitems.find_by(order_item_id: id).destroy 
    # end 


    def current_cart_total 
        "%.2f" % self.current_cart.items.sum(:price)
    end 

    def display_cart
        self.current_cart.items.each do |item|
            puts "PRICE: $#{"%.2f" % item.price}    NAME: #{item.name}    TYPE: #{item.alcohol_type}    ORIGIN: #{item.origin}     RATING: #{item.rating}"
        end
    end

    def add_item_to_cart(item_inst)
        OrderItem.create(order: self.current_cart, item: item_inst)
    end

    def remove_item_from_cart()
    end

    # def change_username(new_username)
    #     if User.find_by(username: new_username)
    #         puts 

    #     until !User.find_by(username: user_name) do
    #         puts "Sorry, that username is already taken. Please enter another username."
    #         user_name = gets.chomp
    #             if user_name.match?(/^\A\w{5,15}\Z$/) && !User.find_by(username: user_name) 
    #                 puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long using only using letters, numbers, and underscores(_)."
    #                 user_name = gets.chomp
    #             elsif User.find_by(username: user_name)
    #                 puts "Sorry, that username is also taken. Please enter another username."
    #                 user_name = gets.chomp
    #             end 
    #     end
                          
    # end

end