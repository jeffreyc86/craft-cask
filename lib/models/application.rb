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
            menu.choice "Exit App", -> {exit_app}
        end
    end

    def buy_alcs
        system 'clear'
        prompt.select("We have the finest spirits to lift up your spirit! How would you like to search?") do |menu|
            menu.choice "Search by name", -> {search_by_name}
            menu.choice "Search by type", -> {search_by_type}
            menu.choice "Search by origin country", -> {search_by_origin}
            menu.choice "Search by price", -> {search_by_price}
            menu.choice "Search by rating", -> {smell_you_later}
            menu.choice "View all", -> {exit_app}
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
                    puts item_inst.description
                    puts "Rating: #{item_inst.rating}"
                    puts "Origin: #{item_inst.origin}"
                    puts "ABV #{item_inst.abv}%"
                    puts "Price: $#{"%.2f" % item_inst.price}"
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
            options = aoa_alc_info.map do |arr| 
                {"PRICE: $#{"%.2f" % arr[1]}    NAME: #{arr[2]}    ORIGIN: #{arr[3]}     RATING: #{arr[4]}" => arr[0]}
            end << [{"Search for a different type of spirt" => "Search for a different type of spirt"}, {"Search by a different critera" => "Search by a different critera"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
            #     # puts File.read("lib/wordart/#{alc}.txt")
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
                        puts item_inst.description
                        puts "Rating: #{item_inst.rating}"
                        puts "Origin: #{item_inst.origin}"
                        puts "ABV #{item_inst.abv}%"
                        puts "Price: $#{"%.2f" % item_inst.price}"
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
        prompt.select("Which price range would you like to explore?") do |menu|
            menu.choice "$0 - $50", -> {first_range}
            menu.choice "$51 - $100", -> {second_range}
            menu.choice "$101 - $150", -> {third_range}
            menu.choice "$150+", -> {fourth_range}
        end 
    end 

        def price_range_helper(price_range_str, price_range)
            puts "Here is a list of our finest spirits in the #{price_range_str} range:"
            items_in_price_range = Item.where(:price => price_range) 
            aoa_alc_info = items_in_price_range.map { |alco| [alco.id, alco.price, alco.name, alco.origin] }
                alc_ids = items_in_price_range.map { |alco| alco.id }
                    aoa_alc_info.each do |arr|
                        puts "ID: #{arr[0]}    PRICE: $#{"%.2f" % arr[1]}    NAME: #{arr[2]}    ORIGIN: #{arr[3]}"
                    end
            puts "Please enter the ID of the spirit you would like to explore"
            answer = gets.chomp 
            item_inst = Item.find_by(id: answer)
            if item_inst && alc_ids.include?(answer)
                puts item_inst.description
                puts "Rating: #{item_inst.rating}"
                puts "Origin: #{item_inst.origin}"
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore additional another option within the #{price_range_str} range", -> {price_range_helper(price_range_str, price_range)}
                    menu.choice "Explore options by another price range", -> {search_by_price}
                    menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else 
                prompt.select("Sorry we couldn't find a spirit with that ID in the range you are looking for") do |menu|
                    menu.choice "Explore additional options within the #{price_range_str} range", -> {price_range_helper(price_range_str, price_range)}
                    menu.choice "Explore options by another price range", -> {search_by_price}
                    menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end  
            end 
        end 

        def first_range 
            range = 0.0..50.99
            price_range_helper("$0 - $50", range)
        end 
    
        def second_range
            range = 51.0..100.99
            price_range_helper("$51 - $100", range)
        end

        def third_range
            range = 101.0..150.99
            price_range_helper("$101 - $150", range)
        end

        def fourth_range 
            range = 151.0..100000000.0
            puts "You're a big baller!"
            price_range_helper("$150+", range)  
        end
    
    def search_by_rating

        #4+ 
            #spit out array of items with rating of 4+
            #enter item id you want to learn about
        #3+
            #enter item id you want to learn about
        #2+
            #enter item id you want to learn about
        #1+
            #enter item id you want to learn about
        #unrated
            #enter item id you want to learn about
    end 

    def search_by_rating_helper 
    #view_all
        #display all items
        #enter id of item you want to purchase
    end 
    
     #******** copy for other search by method
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
                    puts item_inst.description
                    puts "ABV #{item_inst.abv}%"
                    puts "Price: $#{"%.2f" % item_inst.price}"
                    prompt.select("Would you like to:") do |menu|
                        menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                        menu.choice "Explore additional spirits from #{country}", -> {purchase_by_origin(country)}
                        menu.choice "Explore spirits from a different origin", -> {search_by_origin}
                        menu.choice "Explore spirits by a different criteria", -> {buy_alcs}
                        menu.choice "Return to Main Menu", -> {main_menu}
                    end 
            end
        end

    def add_to_cart(item)
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
            prompt.select("Sorry #{item_inst.name} is currently out of stock. Would you like to:") do |menu|
                menu.choice "Find an alternative", -> {buy_alcs}
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
        #system clear
        system 'clear'
        #Please enter the item id you want to delete
        puts "Please enter the item id you want to remove from your current cart"
        #list of items id, name, price of current cart
        user.current_cart.items.each do |item| 
        puts "ID: #{item.id} NAME: #{item.name} PRICE: $#{item.price}"
        end 
        id = gets.chomp
        item = user.current_cart.items.find_by(id: id)
        order_item_inst = user.current_cart.order_items.find_by(item_id: id)
            if user.current_cart.items.exclude?(item)  
                prompt.select("There's nothing with that item ID in your cart. Would you like to:") do |menu|
                menu.choice "Enter the correct id of the item you want to remove", -> {remove_item}
                menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
               order_item_inst.destroy
                prompt.select("#{item.name} has been removed from your cart! Your current total is now $#{user.current_cart_total}. What would you like to do next:") do |menu|
                    menu.choice "Remove another item", -> {remove_item}
                    menu.choice "Add more items to your cart", -> {buy_alcs}
                    menu.choice "Return to Main Menu", -> {main_menu}
                    menu.choice "Exit App", -> {exit_app} 
                end 
            end       
              
    end


    def try_again
        prompt.select("Sorry we couldn't find a match. What would you like to do next?") do |menu|
            menu.choice "Search by a different name", -> {search_by_name}
            menu.choice "Search by type of spirt", -> {search_by_type}
            menu.choice "Return to Main Menu", -> {main_menu}
        end
    end

    def exit_app
        puts "Peace out homie!"
        exit
    end

    

end

