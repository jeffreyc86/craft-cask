require 'highline/import'
require 'rainbow'
using Rainbow

class User < ActiveRecord::Base

    has_many :reviews
    has_many :orders
    has_many :order_items, through: :orders

    def self.password_prompt(message, mask= '*')
        ask(message) { |q| q.echo = mask }
    end

    def self.login_a_user
        puts "Welcome Back!"
        puts "Please enter your USERNAME."
        userName = gets.chomp
        pass = password_prompt("Please enter your PASSWORD.")

        user = User.find_by(username: userName, password: pass)

        if !User.find_by(username: userName)
            TTY::Prompt.new.select("Sorry, no account with that USERNAME exists. Would you like to") do |menu|
            menu.choice "Login again", -> {login_a_user}
            menu.choice "Register", -> {register_a_user}
            menu.choice "Exit", -> {exit_app} 
            end
            
        elsif User.find_by(username: userName) && !user
            TTY::Prompt.new.select("Sorry you've entered the wrong USERNAME or PASSWORD. Would you like to") do |menu|
            menu.choice "Login again", -> {login_a_user}
            menu.choice "Register", -> {register_a_user}
            menu.choice "Exit", -> {exit_app}
            end

        else
            user
        end
    end

        def self.exit_app
            system 'clear'
            puts Rainbow(File.read("lib/wordart/til_we_drink.txt")).tomato.bright
            puts Rainbow(File.read("lib/wordart/exit_app.txt")).teal.bright
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
                        puts "Thank you! Now please enter your FIRST NAME"
                        firstName = gets.chomp

                            until firstName.match?(/^\A([a-zA-Z]|-){2,30}\Z$/) do
                                puts "Please re-enter your FIRST NAME using only letters or hyphens."
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
                                puts "Sorry, that username is already taken. Please enter another USERNAME."
                                user_name = gets.chomp
                                    if !user_name.match?(/^\A\w{5,15}\Z$/) 
                                        puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long using only using letters, numbers, and underscores(_)."
                                        user_name = gets.chomp
                                            until user_name.match?(/^\A\w{5,15}\Z$/) do
                                                puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long using only using letters, numbers, and underscores(_)."
                                                user_name = gets.chomp
                                            end 
                                    elsif User.find_by(username: user_name)
                                        puts "Sorry, that username is also taken. Please enter another USERNAME."
                                        user_name = gets.chomp
                                            until user_name.match?(/^\A\w{5,15}\Z$/) do
                                                puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long using only using letters, numbers, and underscores(_)."
                                                user_name = gets.chomp
                                            end 
                                    end 
                            end

                        pass_word = password_prompt("And lastly, please enter a PASSWORD 5-15 characters long")

                            until pass_word.match?(/^\A\S{5,15}\Z$/) do
                                pass_word = password_prompt("Please enter a PASSWORD 5-15 characters long.")
                            end

                        pass_word2 = password_prompt("Please re-enter your PASSWORD")

                            until pass_word == pass_word2 do
                                pass_word = password_prompt("Sorry the passwords did not match. Please enter a PASSWORD.")
                                    until pass_word.match?(/^\A\S{5,15}\Z$/) do
                                        pass_word = password_prompt("Please enter a PASSWORD 5-15 characters long.")
                                    end
                                pass_word2 = password_prompt("Please re-enter your PASSWORD")
                            end

                        user = User.create(first_name: firstName.capitalize, username: user_name, password: pass_word)
                        user.update(age: age.to_i)
                        user
                    else
                        puts Rainbow(File.read("lib/wordart/stop_uad.txt")).red.bright
                        puts Rainbow(File.read("lib/wordart/think_before.txt")).cyan.bright
                        puts "Use your brain wisely. Your time will come. Don't rush."
                        puts "We'll meet again when you are 21."
                        exit 
                    end
            else
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
        system 'clear'
        puts Rainbow(File.read("lib/wordart/check_out.txt")).mediumspringgreen.bright

        destroy_all_order_items_if_sold_out
        puts "Hope you found everything you were looking for, #{self.first_name}. Below are all the items in your cart:"
        display_cart
        puts "This order of #{current_cart_total} has been #{processed}."
        current_cart.items.each { |item| item.update(inventory: item.inventory - 1) }
        current_cart.update(checked_out: true)
    end

        def processed
            Rainbow("processed").red.bright
        end

    def check_out_after_viewing_cart
        system 'clear'
        puts Rainbow(File.read("lib/wordart/check_out.txt")).mediumspringgreen.bright
        puts "Below are all the items in your cart:"
        self.display_cart
        puts "This order of #{current_cart_total} has been #{processed}."
        self.current_cart.items.each { |item| item.update(inventory: item.inventory - 1) }
        self.current_cart.update(checked_out: true)
    end

    def view_current_cart
        destroy_all_order_items_if_sold_out
        puts "Hope you're finding everything you are looking for, #{self.first_name}."
        puts "Below are all the items currently in your cart:"
        self.display_cart
    end

    def destroy_all_order_items_if_sold_out
        sold_out_items = current_cart.items.where(inventory: 0)
        sold_out_items.each do |item|
            OrderItem.find_by(order_id: current_cart.id, item_id: item.id).destroy
            puts Rainbow("Sorry, unfortunately #{item.name} is currently out of stock. It has been removed.").red.bright
        end
    end

    def current_cart_total 
        Rainbow("$#{"%.2f" % self.current_cart.items.sum(:price)}").red.bright
    end 

    def display_cart
        self.current_cart.items.each do |item|
            puts "PRICE: $#{"%.2f" % item.price}    NAME: #{item.name}    TYPE: #{item.alcohol_type}    ORIGIN: #{item.origin}     RATING: #{item.rating}"
        end
    end

    def add_item_to_cart(item_inst)
        OrderItem.create(order: self.current_cart, item: item_inst)
    end

end