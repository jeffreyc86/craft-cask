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
            menu.choice "View Your Cart", -> {see_all_pets}
            menu.choice "View Order History", -> {smell_you_later}
            menu.choice "Review Your Favorites", -> {smell_you_later}
            menu.choice "Exit App", -> {exit_app}
        end
    end

    def buy_wines

        prompt.select("We have the finest spirits to lift up your spirit! How would you like to search?") do |menu|
            menu.choice "Search by name", -> {search_by_name}
            menu.choice "Search by type", -> {search_by_type}
            menu.choice "Search by price", -> {smell_you_later}
            menu.choice "Search by rating", -> {smell_you_later}
            menu.choice "View all", -> {exit_app}
        end
        
    end

    def search_by_name
        puts "What is the name of the spirit you are looking?"
        answer = gets.chomp 
        sorted_list = Item.where(name: '%answer%')
        if Item.find_by(name: '%answer%')
            puts "These were the search results"
            arr_of_items_id = sorted_list.map { |item| {item.name => item.id} }
            arr_of_items_id.each do |name, id|
                puts "ID: #{id}  NAME: #{name}"
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

    # def search_by_type

    #     prompt.select("Which type of alcohol were you looking for?") do |menu|
    #         menu.choice "Gin", -> {buy_gin}
    #         menu.choice "No", -> {try_again}

    #     #gin, Liquer, Mezcal, Rum, Tequila, Vodka, Whiskey
    #     puts "What is the type of spirit you are looking for?"
    #     answer = gets.chomp 
    #     sorted_list = Item.where(name: '%answer%')
    #     if Item.find_by(name: '%answer%')
    #         puts "These were the search results"
    #         arr_of_items_id = sorted_list.map { |item| {item.name => item.id} }
    #         arr_of_items_id.each do |name, id|
    #             puts "ID: #{id}  NAME: #{name}"
    #         end
    #         prompt.select("Were any of these what you were looking for?") do |menu|
    #             menu.choice "Yes", -> {purchase_by_id}
    #             menu.choice "No", -> {try_again}
    #         end
    #     else
    #         prompt.select("Sorry we couldn't find anything resembling that name. Would you like to:") do |menu|
    #             menu.choice "Try a different name", -> {search_by_name}
    #             menu.choice "Search by a different critera", -> {search_by_type}
    #             menu.choice "Return to Main Menu", -> {main_menu}
    #         end 
    #     end 
    # end 

    def buy_gin
        #.where(“col_name > ?”, value_you_want)
        gins = Item.where("alcohol_type = ?", "inventory > ?", "Gin", 0)
       # Book.where(category: "Programming").or(Book.where(category: "Ruby"))
        puts "This is a list of our available Gins."
            gins_and_ids = gins.map { |gin| {gin.name => gin.id} }
            gins_and_ids.each do |name, id|
                puts "ID: #{id}  NAME: #{name}"
            end 
        puts "Please enter the ID of the Gin you would like to learn more about."
        answer = gets.chomp
        item_inst = Item.find(answer)
            if item_inst 
                puts item_inst.description
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add #{item_inst.name} to cart", -> {add_to_cart(item_inst)}
                    menu.choice "Explore different Gins", -> {buy_gin}
                    menu.choice "Explore different types of spirits", -> {search_by_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
            else
                puts "Sorry there is no item by that ID. Please try again."
                self.buy_gin
            end 
    end 


    def add_to_cart(item_inst)
        if item_inst.inventory >= 1
        user.add_item_to_cart(item_inst)
                puts "#{item_inst.name} has been added to your cart."
                prompt.select("Would you like to:") do |menu|
                    menu.choice "Add additional items to your cart", -> {buy_wines}
                    menu.choice "Check out", -> {check_out}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end 
        else
            prompt.select("Sorry #{item_inst.name} is currently out of stock. Would you like to:") do |menu|
                menu.choice "Find an alternative", -> {buy_wines}
                menu.choice "View current cart", -> {view_cart}
                menu.choice "Return to Main Menu", -> {main_menu}
            end 
        end 
    end 



    def purchase_by_id
        puts "Please enter the ID of the item you'd like to purchase."
        answer = gets.chomp
        item_inst = Item.find(answer)

            if item_inst 
                add_to_cart(item_inst)
            else
                puts "Sorry there is no item by that ID. Please try again."
                self.purchase_by_id
            end
    end

    def view_cart
        user.view_current_cart
        prompt.select("Your total so far is $#{user.current_cart_total}. Would you like to:") do |menu|
            menu.choice "Check Out", -> {already_viewed_checkout}
            menu.choice "Return to Main Menu", -> {main_menu}
            menu.choice "Exit App", -> {exit_app}
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


    def try_again
    end

    def exit_app
        puts "Peace out homie!"
    end

    

end