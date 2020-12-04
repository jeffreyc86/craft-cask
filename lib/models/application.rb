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
        prompt.select("Would you like to register or login?") do |menu|
            menu.choice "Register", -> {register_helper}
            menu.choice "Login", -> {login_helper}
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
            menu.choice "Explore & Shop", -> {buy_wines}
            menu.choice "View Your Cart", -> {view_cart}
            menu.choice "View Order History", -> {smell_you_later}
            menu.choice "Review Your Favorites", -> {smell_you_later}
            menu.choice "Exit App", -> {exit_app}
        end
    end

    def buy_wines

        prompt.select("We have the finest spirits to lift up your spirit! How would you like to search?") do |menu|
            menu.choice "Search by name", -> {search_by_name}
            menu.choice "Search by type", -> {search_by_type}
            menu.choice "Search by origin country", -> {search_by_origin}
            menu.choice "Search by price", -> {smell_you_later}
            menu.choice "Search by rating", -> {smell_you_later}
            menu.choice "View all", -> {exit_app}
        end
        
    end

    #Complete - Don't Change
    def search_by_name
        puts "What is the name of the spirit you are looking?"
        answer = gets.chomp 
        sorted_list = Item.where("name LIKE ?", "%#{answer}%")
        if Item.find_by("name LIKE ?", "%#{answer}%")
            puts "These were the search results"
            aoa_items_id = sorted_list.map { |item| [item.id, item.name] }
            aoa_items_id.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]}"
            end
            prompt.select("Were any of these what you were looking for?") do |menu|
                menu.choice "Yes", -> {purchase_by_id}
                menu.choice "No", -> {try_again}
            end
        else
            prompt.select("Sorry we couldn't find anything resembling that name. Would you like to:") do |menu|
                menu.choice "Try a different name", -> {search_by_name}
                menu.choice "Search by a different critera", -> {buy_wines}
                menu.choice "Return to Main Menu", -> {main_menu}
            end 
        end 
    end 

    #Complete - below method until
    def search_by_type
        system 'clear'
         prompt.select("Which type of alcohol were you looking for?") do |menu|
             menu.choice "Cognac", -> {buy_cog}
             menu.choice "Gin", -> {buy_gin} #112
             menu.choice "Liquer", -> {buy_liq}
             menu.choice "Mezcal", -> {buy_mez}
             menu.choice "Rum", -> {buy_rum}
             menu.choice "Tequila", -> {buy_teq}
             menu.choice "Vodka", -> {buy_vod}
             menu.choice "Whiskey", -> {buy_whisk}
         end
    end

    def buy_cog
        cognacs = Item.where("alcohol_type = ?", "Cognac")
        puts "This is a list of our available Cognacs."
            aoa_cogs_info = cognacs.map { |cog| [cog.id, cog.name, cog.price] }
            cog_ids = cognacs.map { |cog| cog.id }
            aoa_cogs_info.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]} PRICE: $#{"%.2f" % arr[2]}"
            end
        puts "Please enter the ID of the Cognac you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
            if item_inst && cog_ids.include?(answer.to_i)
                puts item_inst.description
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Cognacs", -> {buy_cog}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                prompt.select("Sorry there is no cognac by that ID. Would you like to:") do |menu|
                    menu.choice "Explore different Cognacs", -> {buy_cog}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end 
    end 
    
    def buy_liq
        liquers = Item.where("alcohol_type = ?", "Liquer")
        puts "This is a list of our available Liquers."
            aoa_liqs_info = liquers.map { |liq| [liq.id, liq.name, liq.price] }
            liq_ids = liquers.map { |liq| liq.id }
            aoa_liqs_info.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]} PRICE: $#{"%.2f" % arr[2]}"
            end
        puts "Please enter the ID of the Liquer you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
            if item_inst && liq_ids.include?(answer.to_i)
                puts item_inst.description
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Liquers", -> {buy_gin}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                prompt.select("Sorry there is no Liquer by that ID. Would you like to:") do |menu|
                    menu.choice "Explore different Liquers", -> {buy_liq}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end 
    end  

    def buy_mez
        mezcals = Item.where("alcohol_type = ?", "Mezcal")
        puts "This is a list of our available Mezcals."
            aoa_mezs_info = mezcals.map { |mez| [mez.id, mez.name, mez.price] }
            mez_ids = mezcals.map { |mez| mez.id }
            aoa_mezs_info.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]} PRICE: $#{"%.2f" % arr[2]}"
            end
        puts "Please enter the ID of the Mezcal you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
            if item_inst && mez_ids.include?(answer.to_i)
                puts item_inst.description
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Mezcals", -> {buy_gin}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                prompt.select("Sorry there is no Mezcal by that ID. Would you like to:") do |menu|
                    menu.choice "Explore different Mezcals", -> {buy_mez}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end 
    end  

    def buy_rum
        rums = Item.where("alcohol_type = ?", "rum")
        puts "This is a list of our available Rums."
            aoa_rums_info = rums.map { |rum| [rum.id, rum.name, rum.price] }
            rum_ids = rums.map { |rum| rum.id }
            aoa_rums_info.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]} PRICE: $#{"%.2f" % arr[2]}"
            end
        puts "Please enter the ID of the Rum you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
            if item_inst && rum_ids.include?(answer.to_i)
                puts item_inst.description
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Rums", -> {buy_rum}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                prompt.select("Sorry there is no rum by that ID. Would you like to:") do |menu|
                    menu.choice "Explore different Rums", -> {buy_rum}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end 
    end  

    def buy_gin
        gins = Item.where("alcohol_type = ?", "Gin")
        puts "This is a list of our available Gins."
            aoa_gins_info = gins.map { |gin| [gin.id, gin.name, gin.price] }
            gin_ids = gins.map { |gin| gin.id }
            aoa_gins_info.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]} PRICE: $#{"%.2f" % arr[2]}"
            end
        puts "Please enter the ID of the Gin you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
            if item_inst && gin_ids.include?(answer.to_i)
                puts item_inst.description
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Gins", -> {buy_gin}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                prompt.select("Sorry there is no Gin by that ID. Would you like to:") do |menu|
                    menu.choice "Explore different Gins", -> {buy_gin}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end 
    end 

    def buy_teq
        tequilas = Item.where("alcohol_type = ?", "Tequila")
        puts "This is a list of our available Tequilas."
            aoa_teqs_info = tequilas.map { |teq| [teq.id, teq.name, teq.price] }
            teq_ids = tequilas.map { |teq| teq.id }
            aoa_teqs_info.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]} PRICE: $#{"%.2f" % arr[2]}"
            end
        puts "Please enter the ID of the Tequila you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
            if item_inst && teq_ids.include?(answer.to_i)
                puts item_inst.description
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Tequilas", -> {buy_gin}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                prompt.select("Sorry there is no Tequila by that ID. Would you like to:") do |menu|
                    menu.choice "Explore different Tequilas", -> {buy_teq}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end 
    end 

    def buy_vod
        vodkas = Item.where("alcohol_type = ?", "Vodka")
        puts "This is a list of our available Vodkas."
            aoa_vods_info = vodkas.map { |vodka| [vodka.id, vodka.name, vodka.price] }
            vod_ids = vodkas.map { |vodka| vodka.id }
            aoa_vods_info.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]} PRICE: $#{"%.2f" % arr[2]}"
            end
        puts "Please enter the ID of the Vodka you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
            if item_inst && vod_ids.include?(answer.to_i)
                puts item_inst.description
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Vodkas", -> {buy_vod}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                prompt.select("Sorry there is no Vodka by that ID. Would you like to:") do |menu|
                    menu.choice "Explore different Vodkas", -> {buy_vod}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end 
    end 

    def buy_whisk
        whiskeys = Item.where("alcohol_type = ?", "Whiskey")
        puts "This is a list of our available Whiskeys."
            aoa_whisk_info = whiskeys.map { |whisk| [whisk.id, whisk.name, whisk.price] }
            whisk_ids = whiskeys.map { |whisk| whisk.id }
            aoa_whisk_info.each do |arr|
                puts "ID: #{arr[0]}  NAME: #{arr[1]} PRICE: $#{"%.2f" % arr[2]}"
            end
        puts "Please enter the ID of the Whiskey you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find_by(id: answer)
            if item_inst && whisk_ids.include?(answer.to_i)
                puts item_inst.description
                puts "ABV #{item_inst.abv}%"
                puts "Price: $#{"%.2f" % item_inst.price}"
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Whiskeys", -> {buy_whisk}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                prompt.select("Sorry there is no Whiskey by that ID. Would you like to:") do |menu|
                    menu.choice "Explore different Whiskeys", -> {buy_whisk}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end 
    end 

    #search_by_

    def add_to_cart(item)
        if item.inventory >= 1
        user.add_item_to_cart(item)
                puts "#{item.name} has been added to your cart."
                prompt.select("Would you like to:") do |menu|
                    menu.choice "View your current cart", -> {view_cart}
                    menu.choice "Add additional items to your cart", -> {buy_wines}
                    menu.choice "Check out", -> {check_out}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
        elsif
            prompt.select("Sorry #{item_inst.name} is currently out of stock. Would you like to:") do |menu|
                menu.choice "Find an alternative", -> {buy_wines}
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
        if user.current_cart.items.count <= 0 
        prompt.select("Sorry there's currently nothing in your cart. Would you like to:") do |menu|
            menu.choice "Explore new spirits", -> {buy_wines}
            menu.choice "Return to Main Menu", -> {main_menu}
            menu.choice "Exit App", -> {exit_app}
        end 
        else 
            user.view_current_cart
            prompt.select("Your total so far is $#{user.current_cart_total}. Would you like to:") do |menu|
            menu.choice "Check Out", -> {already_viewed_checkout}
            menu.choice "Remove an item from your cart", -> {remove_item}
            menu.choice "Add more items to your cart", -> {buy_wines}
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
                    menu.choice "Add more items to your cart", -> {buy_wines}
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

