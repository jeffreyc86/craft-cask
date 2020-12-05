class Application

    attr_reader :prompt
    attr_accessor :user

    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome 
        puts "Hi! Welcome to APP_NAME. Discover your new favorite spirit."
    end

    def ask_user_for_login_or_register
        # # app name display
        puts File.read("lib/wordart/app_banner.txt")
        prompt.select("Would you like to register or login?") do |menu|
            menu.choice "Login", -> {login_helper}
            menu.choice "Register", -> {register_helper}
            menu.choice "Alcohol is not for me", -> {exit_app}
        end
    end

    def login_helper
        User.login_a_user
    end

    def register_helper
        User.register_a_user
    end

    def main_menu
        user.reload
        # Gets the most up to date info about the user
        
        system 'clear'
        # "clears" the terminal

        # sleep 5
        # Wait 5 seconds and then execute
        prompt.select("Welcome, #{user.first_name}! What do you want to do?") do |menu|
            menu.choice "Explore & Shop", -> {buy_alcs}
            menu.choice "View Your Cart", -> {view_cart}
            menu.choice "View Order History", -> {smell_you_later}
            menu.choice "Review Your Favorites", -> {smell_you_later}
            menu.choice "View Account Settings", -> {account_settings}
            menu.choice "Exit App", -> {exit_app}
        end
    end

    def account_settings
        system 'clear'
        prompt.select("Hello, #{user.first_name}! Please select from the following options") do |menu|
        menu.choice "Change your First Name", -> {change_name}
        menu.choice "Change your Username", -> {change_username}
        menu.choice "Update your Password", -> {change_password}
        menu.choice "View Order History", -> {smell_you_later}
        menu.choice "Delete Account", -> {delete_account}
        menu.choice "Return to Main Menu", -> {main_menu}
        end
    end

    def change_password
      system 'clear'
      puts "Happy to help you change your PASSWORD, #{user.first_name}. Please enter your current password"
      answer = gets.chomp

          until answer == user.password do
              puts "Sorry you're entered an incorrect password. Please re-enter your current password."
              answer = gets.chomp
          end

      puts "Please enter your new password"
      pass_word = gets.chomp 
      
          until pass_word.match?(/^\A\S{5,15}\Z$/) do
              puts "Please enter a password 5-15 characters long."
              pass_word = gets.chomp
          end

      puts "Please re-enter your new password"
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
        
        user.update(password: pass_word)
        prompt.select("Thank you, #{user.first_name}. Your PASSWORD has been updated. Please select what you'd like to do next") do |menu|
          menu.choice "Return to Account Settings", -> {account_settings}
          menu.choice "Explore & Shop", -> {buy_alcs}
          menu.choice "Return to Main Menu", -> {main_menu}
        end
    end

    def change_name
        system 'clear'
        puts "Happy to help you change your name in our system. Please enter your first name."
        answer = gets.chomp
  
        until answer.match?(/^\A([a-zA-Z]|-){2,30}\Z$/) do
          puts "Please enter your first name using only letters or hyphens."
          firstName = gets.chomp
        end 
          
        user.update(first_name: answer)
          prompt.select("Thank you, #{user.first_name}. Your name has been updated. Please select what you'd like to do next") do |menu|
            menu.choice "Return to Account Settings", -> {account_settings}
            menu.choice "Explore & Shop", -> {buy_alcs}
            menu.choice "Return to Main Menu", -> {main_menu}
          end
    end

    def change_username
        system 'clear'
        puts "Happy to help you change your USERNAME, #{user.first_name}. Please enter your a new username."
        puts "Enter 5-15 characters using letters, numbers, and underscores(_)"
        answer = gets.chomp

        until answer.match?(/^\A\w{5,15}\Z$/) do
            puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long, using only using letters, numbers, and underscores(_)."
            answer = gets.chomp
        end 

        until !User.find_by(username: answer) do
            puts "Sorry, that username is already taken. Please enter another username."
            answer = gets.chomp
                if !answer.match?(/^\A\w{5,15}\Z$/) 
                    puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long using only using letters, numbers, and underscores(_)."
                    answer = gets.chomp
                elsif User.find_by(username: answer)
                    puts "Sorry, that username is also taken. Please enter another username."
                    answer = gets.chomp
                end 
        end
              
        user.update(username: answer)
        prompt.select("Thank you, #{user.first_name}. Your username has been updated to #{user.username}. Please select what you'd like to do next") do |menu|
          menu.choice "Return to Account Settings", -> {account_settings}
          menu.choice "Explore & Shop", -> {buy_alcs}
          menu.choice "Return to Main Menu", -> {main_menu}
        end
    end

    def delete_account
        system 'clear'
          choice = prompt.select("So sad to see you go! 😭😭💔 Are you sure you want to delete your account, #{user.first_name}?", ["Yes", "No"]) 
          
        if choice == "Yes"
            puts "Confirming again that you would like to delete your account. All previous order history will no longer be available and the account will be deleted forever."
            answer = prompt.select("Are you sure you want to delete your account, #{user.first_name}?", ["Yes", "No"]) 
                if answer == "Yes"
                    system 'clear'
                    puts "Goodbye forever, #{user.first_name}. Hope you'll shop with us again soon."
                    user.destroy
                    prompt.select("What you'd like to do next") do |menu|
                    menu.choice "Register a new account", -> {register_after_deletion}
                    menu.choice "Exit App", -> {exit_app}
                    end
                else
                    prompt.select("Glad we didn't lose you, #{user.first_name}! Please select what you'd like to do next") do |menu|
                    menu.choice "Return to Account Settings", -> {account_settings}
                    menu.choice "Explore & Shop", -> {buy_alcs}
                    menu.choice "Return to Main Menu", -> {main_menu}
                    end
                end
        else
            prompt.select("Glad we didn't lose you, #{user.first_name}! Please select what you'd like to do next") do |menu|
            menu.choice "Return to Account Settings", -> {account_settings}
            menu.choice "Explore & Shop", -> {buy_alcs}
            menu.choice "Return to Main Menu", -> {main_menu}
            end
            
        end

    end

        def register_after_deletion
            User.register_a_user
            main_menu
        end
        

    def buy_alcs
        system 'clear'
        prompt.select("We have the finest spirits to lift up your spirit! How would you like to search?") do |menu|
            menu.choice "Search by name", -> {search_by_name}
            menu.choice "Search by type", -> {search_by_type}
            menu.choice "Search by origin country", -> {search_by_origin}
            menu.choice "Search by price", -> {search_by_price}
            menu.choice "Search by rating", -> {search_by_rating}
            menu.choice "View all", -> {view_all}
        end
        
    end

    def search_by_name
        puts "What is the name of the spirit you are looking?"
        answer = gets.chomp 
        alcohols = Item.where("name LIKE ?", "%#{answer}%")
        if Item.find_by("name LIKE ?", "%#{answer}%")
            aoa_alc_info = alcohols.map { |alco| [alco.id, alco.price, alco.alcohol_type, alco.name, alco.origin, alco.rating] } 
            options = aoa_alc_info.map do |arr| 
                {"PRICE: $#{"%.2f" % arr[1]}    TYPE: #{arr[2]}    NAME: #{arr[3]}    ORIGIN: #{arr[4]}     RATING: #{arr[5]}" => arr[0]}
            end << [{"Try a different name" => "Try a different name"}, {"Search by a different critera" => "Search by a different critera"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
            choice = prompt.select("These were the following results we found. Please select an option", options) 
                if choice == "Try a different name"
                    search_by_name
                elsif choice == "Search by a different critera"
                    buy_alcs
                elsif choice == "Return to Main Menu"
                    main_menu
                else 
                    item_inst = Item.find(choice)
                    system 'clear'
                    puts "NAME: #{item_inst.name}"
                        puts item_inst.description
                        puts "RATING: #{item_inst.rating}"
                        puts "ORIGIN: #{item_inst.origin}"
                        puts "ABV #{item_inst.abv}%"
                        puts "PRICE: $#{"%.2f" % item_inst.price}"
                    prompt.select("Would you like to:") do |menu|
                        menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                        menu.choice "Search for another spirit by name", -> {search_by_name}
                        menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                        menu.choice "Return to Main Menu", -> {main_menu}
                    end 
                end
        else
            prompt.select("Sorry we couldn't find anything resembling that name. Would you like to:") do |menu|
                menu.choice "Try a different name", -> {search_by_name}
                menu.choice "Search by a different critera", -> {buy_alcs}
                menu.choice "Return to Main Menu", -> {main_menu}
            end 
        end 
    end 

    def search_by_type
        system 'clear'

        choice = prompt.select("Which type of alcohol were you looking for?", Item.all.pluck(:alcohol_type).uniq)
        purchase_by_type(choice)
    end

        def purchase_by_type(alc)
            system 'clear'
            alcohols = Item.where("alcohol_type = ?", alc)
            aoa_alc_info = alcohols.map { |alco| [alco.id, alco.price, alco.name, alco.origin, alco.rating] } 
            options = aoa_alc_info.map { |arr| {"PRICE: $#{"%.2f" % arr[1]}    NAME: #{arr[2]}    ORIGIN: #{arr[3]}     RATING: #{arr[4]}" => arr[0]} } << [{"Search for a different type of spirt" => "Search for a different type of spirt"}, {"Search by a different critera" => "Search by a different critera"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
                # puts File.read("lib/wordart/#{alc}.txt")
                puts "This is a list of our available #{alc}s."
                choice = prompt.select("Please select the item you would like to learn more about.", options)
            
                if choice == "Return to Main Menu"
                    main_menu
                elsif choice == "Search for a different type of spirt"
                    search_by_type
                elsif choice == "Search by a different critera"
                    buy_alcs
                else 
                    item_inst = Item.find(choice)
                        system 'clear'
                        puts "NAME: #{item_inst.name}"
                        puts item_inst.description
                        puts "RATING: #{item_inst.rating}"
                        puts "ORIGIN: #{item_inst.origin}"
                        puts "ABV #{item_inst.abv}%"
                        puts "PRICE: $#{"%.2f" % item_inst.price}"
                        prompt.select("Would you like to:") do |menu|
                            menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                            menu.choice "Explore additional #{alc}", -> {purchase_by_type(alc)}
                            menu.choice "Explore another spirit types", -> {search_by_type}
                            menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                            menu.choice "Return to Main Menu", -> {main_menu}
                        end 
                end
        end
                
                
    def search_by_price 
        system 'clear'       
        prompt.select("Which price range would you like to explore?") do |menu|
            menu.choice "$0 - $50", -> {price_range_helper("$0 - $50", (0.0..50.99))}
            menu.choice "$51 - $100", -> {price_range_helper("$51 - $100", 51.0..100.99)}
            menu.choice "$101 - $150", -> {price_range_helper("$101 - $150", 101.0..150.99)}
            menu.choice "$150+", -> {fourth_range}
        end 
    end 
        
        def price_range_helper(price_range_str, price_range)
            if !Item.find_by(:price => price_range)
                prompt.select("Sorry, there are no items within that price range. Would you like to") do |menu|
                    menu.choice "Explore spirits from a different price range", -> {search_by_price}
                    menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            else
            items_in_price_range = Item.where(:price => price_range).sort_by(&:price) 
            puts "Here is a list of our finest spirits in the #{price_range_str} range:"  
            aoa_alc_info = items_in_price_range.map { |alco| [alco.id, alco.price, alco.alcohol_type, alco.name, alco.origin, alco.rating] }
            options = aoa_alc_info.map { |arr| {"PRICE: $#{"%.2f" % arr[1]}    TYPE: #{arr[2]}    NAME: #{arr[3]}    ORIGIN: #{arr[4]}     RATING: #{arr[5]}" => arr[0]} } << [{"Search by a different price range" => "Search by a different price range"}, {"Search by a different critera" => "Search by a different critera"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
            choice = prompt.select("Please select the item you would like to learn more about.", options)
    
                if choice == "Return to Main Menu"
                main_menu
                elsif choice == "Search by a different price range"
                search_by_price
                elsif choice == "Search by a different critera"
                buy_alcs
                else 
                item_inst = Item.find(choice)
                    system 'clear'
                    puts "NAME: #{item_inst.name}"
                    puts item_inst.description
                    puts "RATING: #{item_inst.rating}"
                    puts "ORIGIN: #{item_inst.origin}"
                    puts "ABV #{item_inst.abv}%"
                    puts "PRICE: $#{"%.2f" % item_inst.price}"
                    prompt.select("Would you like to:") do |menu|
                        menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                        menu.choice "Explore additional spirits from the #{price_range_str} range.", -> {price_range_helper(price_range_str, price_range)}
                        menu.choice "Explore spirits from a different price range", -> {search_by_price}
                        menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                        menu.choice "Return to Main Menu", -> {main_menu}
                    end 
                end
    
            end    
        end 
        
            def fourth_range 
                range = 151.0..100000000.0
                puts "You're a big baller!"
                price_range_helper("$150+", range)  
            end

    
    def search_by_rating
        system 'clear'
        prompt.select("All of our ratings are created by users like you! Please select the rating you'd like to view by") do |menu|
            menu.choice "4 ⭐️", -> {purchase_by_rating("4 ⭐️", [4.0, 5.0])}
            menu.choice "3 ⭐️", -> {purchase_by_rating("3 ⭐️", [3.0, 3.99])}
            menu.choice "2 ⭐️", -> {purchase_by_rating("2 ⭐️", [2.0, 2.99])}
            menu.choice "1 ⭐️", -> {purchase_by_rating("1 ⭐️", [1.0, 1.99])}
            menu.choice "0 ⭐️", -> {purchase_by_rating("0 ⭐️",[0.0, 0.99])}
            menu.choice "Unrated Items", -> {purchase_by_rating("Not Yet Rated", "Not Yet Rated")}
        end
    end

        def purchase_by_rating(str, range)
            system 'clear'
            if range == "Not Yet Rated"
                alcohols = Item.all.select { |item| item.rating == "Not Yet Rated" }.sort_by(&:price)
                aoa_alc_info = alcohols.map { |alco| [alco.id, alco.price, alco.alcohol_type, alco.name, alco.origin, alco.rating] } 
                options = aoa_alc_info.map do |arr| 
                {"PRICE: $#{"%.2f" % arr[1]}    TYPE: #{arr[2]}    NAME: #{arr[3]}    ORIGIN: #{arr[4]}     RATING: #{arr[5]}" => arr[0]}
                end << [{"Search by a different rating" => "Search by a different rating"}, {"Search by a different critera" => "Search by a different critera"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
                choice = prompt.select("Here are all our spirits with a #{str} rating. Please select the option you'd like to learn more about.", options)
            
                    if choice == "Return to Main Menu"
                    main_menu
                    elsif choice == "Search by a different rating"
                    search_by_rating
                    elsif choice == "Search by a different critera"
                    buy_alcs
                    else 
                    item_inst = Item.find(choice)
                        system 'clear'
                        puts "NAME: #{item_inst.name}"
                        puts item_inst.description
                        puts "RATING: #{item_inst.rating}"
                        puts "ORIGIN: #{item_inst.origin}"
                        puts "ABV #{item_inst.abv}%"
                        puts "PRICE: $#{"%.2f" % item_inst.price}"
                        prompt.select("Would you like to:") do |menu|
                            menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                            menu.choice "Explore more spirits with a #{str} rating", -> {purchase_by_rating(str, range)}
                            menu.choice "Explore spirits from a different rating rnage", -> {search_by_rating}
                            menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                            menu.choice "Return to Main Menu", -> {main_menu}
                        end 
                    end
            else
                alcohols = Item.all.select { |item| item.rating.to_f.between?(range[0], range[1]) }.sort_by(&:rating)
                if alcohols.count == 0
                    prompt.select("Sorry, there are no spirits with a #{str}. Would you like to") do |menu|
                        menu.choice "Explore spirits from a different rating range", -> {search_by_rating}
                        menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                        menu.choice "Return to Main Menu", -> {main_menu}
                    end
                else
                    aoa_alc_info = alcohols.map { |alco| [alco.id, alco.rating, alco.price, alco.alcohol_type, alco.name, alco.origin] } 
                    options = aoa_alc_info.map do |arr| 
                    {"RATING: #{arr[1]}    PRICE: $#{"%.2f" % arr[2]}    TYPE: #{arr[3]}    NAME: #{arr[4]}    ORIGIN: #{arr[5]}" => arr[0]}
                    end << [{"Search by a different rating" => "Search by a different rating"}, {"Search by a different critera" => "Search by a different critera"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
                    choice = prompt.select("Here are all our spirits with a #{str} rating. Please select the option you'd like to learn more about.", options)
            
                        if choice == "Return to Main Menu"
                        main_menu
                        elsif choice == "Search by a different rating"
                        search_by_rating
                        elsif choice == "Search by a different critera"
                        buy_alcs
                        else 
                        item_inst = Item.find(choice)
                            system 'clear'
                            puts "NAME: #{item_inst.name}"
                            puts item_inst.description
                            puts "RATING: #{item_inst.rating}"
                            puts "ORIGIN: #{item_inst.origin}"
                            puts "ABV #{item_inst.abv}%"
                            puts "PRICE: $#{"%.2f" % item_inst.price}"
                            prompt.select("Would you like to:") do |menu|
                                menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                                menu.choice "Explore more spirits with a #{str} rating", -> {purchase_by_rating(str, range)}
                                menu.choice "Explore spirits from a different rating rnage", -> {search_by_rating}
                                menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                                menu.choice "Return to Main Menu", -> {main_menu}
                            end 
                        end
                end
            end     
        end
    
    def search_by_origin
        system 'clear'
        choice = prompt.select("Please select a country to see all available spirits.", Item.all.pluck(:origin).uniq)
        purchase_by_origin(choice)
    end
        
        def purchase_by_origin(country)
            system 'clear'
            alcohols = Item.where("origin = ?", country)
            aoa_alc_info = alcohols.map { |alco| [alco.id, alco.price, alco.alcohol_type, alco.name, alco.rating] } 
            options = aoa_alc_info.map do |arr| 
                {"PRICE: $#{"%.2f" % arr[1]}    TYPE: #{arr[2]}    NAME: #{arr[3]}    RATING: #{arr[4]}" => arr[0]}
            end << [{"Search by a different region" => "Search by a different region"}, {"Search by a different critera" => "Search by a different critera"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
            # puts File.read("lib/wordart/#{country}.txt")
            puts "This is a list of our available spirits from #{country} ."
            choice = prompt.select("Please select the item you would like to learn more about.", options)
        
            if choice == "Return to Main Menu"
                main_menu
            elsif choice == "Search by a different region"
                search_by_origin
            elsif choice == "Search by a different critera"
                self.buy_alcs
            else 
                item_inst = Item.find(choice)
                    system 'clear'
                    puts "NAME: #{item_inst.name}"
                    puts item_inst.description
                    puts "RATING: #{item_inst.rating}"
                    puts "ORIGIN: #{item_inst.origin}"
                    puts "ABV #{item_inst.abv}%"
                    puts "PRICE: $#{"%.2f" % item_inst.price}"
                    prompt.select("Would you like to:") do |menu|
                        menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                        menu.choice "Explore additional spirits from #{country}", -> {purchase_by_origin(country)}
                        menu.choice "Explore spirits from a different origin", -> {search_by_origin}
                        menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                        menu.choice "Return to Main Menu", -> {main_menu}
                    end 
            end
        end

    def view_all

        system 'clear'
            alcohols = Item.all.sort_by(&:name)
            aoa_alc_info = alcohols.map { |alco| [alco.id, alco.name, alco.price, alco.alcohol_type , alco.origin, alco.rating] }
            options = aoa_alc_info.map { |arr| {"NAME: #{arr[1]}    PRICE: $#{"%.2f" % arr[2]}    TYPE: #{arr[3]}    ORIGIN: #{arr[4]}     RATING: #{arr[5]}" => arr[0]} }.unshift([{"Search by a specific critera" => "Search by a specific critera"}, {"Return to Main Menu" => "Return to Main Menu"}]).flatten
                # puts File.read("lib/wordart/#{alc}.txt")
                puts "Here's a list of all of our spirits in alphabetical order."
                choice = prompt.select("Please select the item you would like to learn more about.", options)
            
                if choice == "Return to Main Menu"
                    main_menu
                elsif choice == "Search by a specific critera"
                    buy_alcs
                else 
                    item_inst = Item.find(choice)
                        system 'clear'
                        puts "NAME: #{item_inst.name}"
                        puts item_inst.description
                        puts "RATING: #{item_inst.rating}"
                        puts "ORIGIN: #{item_inst.origin}"
                        puts "ABV #{item_inst.abv}%"
                        puts "PRICE: $#{"%.2f" % item_inst.price}"
                        prompt.select("Would you like to:") do |menu|
                            menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                            menu.choice "View all again", -> {view_all}
                            menu.choice "Explore spirits by a specific criteria", -> {buy_alcs}
                            menu.choice "Return to Main Menu", -> {main_menu}
                        end 
                end
    end

    

    def add_to_cart(item)
        system 'clear'
        if item.inventory >= 1
        user.add_item_to_cart(item)
                puts "#{item.name} has been added to your cart."
                prompt.select("Would you like to:") do |menu|
                    menu.choice "View your current cart", -> {view_cart}
                    menu.choice "Add additional items to your cart", -> {buy_alcs}
                    menu.choice "Check out", -> {check_out}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
        elsif
            prompt.select("Sorry #{item.name} is currently out of stock. Would you like to:") do |menu|
                menu.choice "Find an alternative #{item.alcohol_type}", -> {purchase_by_type(item.alcohol_type)}
                menu.choice "Add other items to cart", -> {buy_alcs}
                menu.choice "View your current cart", -> {view_cart}
                menu.choice "Return to Main Menu", -> {main_menu}
            end 
        end 
    end 



    def purchase_by_id
        puts "Please enter the ID of the item you'd like to purchase."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
        
            if item_inst
                add_to_cart(item_inst)
                #calls on 139 method
            else 
                system 'clear'
                puts "Sorry there is no item by that ID. Try again."
                sleep 2
                self.purchase_by_id 
            end
    end
#edit to order_inst if cart has items
    def view_cart
        system 'clear'
        if user.current_cart.items.count <= 0 
            #sad face art
        prompt.select("Sorry there's currently nothing in your cart. Would you like to:") do |menu|
            menu.choice "Explore new spirits", -> {buy_alcs}
            menu.choice "Return to Main Menu", -> {main_menu}
            menu.choice "Exit App", -> {exit_app}
        end 
        else 
            user.view_current_cart
            prompt.select("Your total so far is $#{user.current_cart_total}. Would you like to:") do |menu|
            menu.choice "Check Out", -> {already_viewed_checkout}
            menu.choice "Remove an item from your cart", -> {remove_item}
            menu.choice "Add more items to your cart", -> {buy_alcs}
            menu.choice "Return to Main Menu", -> {main_menu}
            menu.choice "Exit App", -> {exit_app} 
            end            
        end 
    end

    def already_viewed_checkout 
        user.check_out_after_viewing_cart
        prompt.select("What would you like to do next?") do |menu|
            menu.choice "Return to Main Menu", -> {main_menu}
            menu.choice "Exit App", -> {exit_app}
            end 
    end 

    def check_out
        user.check_out_current_cart
        prompt.select("Thank you for your purchase! Would you like to:") do |menu|
            menu.choice "Return to Main Menu", -> {main_menu}
            menu.choice "Exit App", -> {exit_app}
        end
    end

    def remove_item
        system 'clear'
        # if user.current_cart.items.count == 0
            #puts "message"
        # else
        options = user.current_cart.items.collect {|item| {"NAME: #{item.name} PRICE: $#{item.price} RATING: #{item.rating}" => item.id}}
        choice = prompt.multi_select("Which item(s) would you like to remove? (Use Spacebar to choose items, then press ENTER to complete removal).  If no items are selected and you press ENTER, you will be returned back to your cart.", options)
        oi_insts_to_delete = choice.map { |id_for_item| user.current_cart.order_items.find_by(item_id: id_for_item) }
        item_names = choice.collect {|id| Item.find(id).name}
        oi_insts_to_delete.each {|order_item_inst| order_item_inst.delete }
            if choice == []
                view_cart
            else 
                prompt.select("These item(s) have been removed from your cart: #{item_names[0]}\n\ Your current total is now $#{user.current_cart_total}. What would you like to do next:") do |menu|
                    menu.choice "Remove another item", -> {remove_item}
                    menu.choice "Add more items to your cart", -> {buy_alcs}
                    menu.choice "Return to Main Menu", -> {main_menu}
                    menu.choice "Exit App", -> {exit_app} 
                end 
            end     
    end

    def exit_app
        puts "Peace out homie!"
        exit
        #edit exit_app class method in user
    end

    

end

