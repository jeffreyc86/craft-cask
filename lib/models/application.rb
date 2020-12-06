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
            menu.choice "Review Your Favorites", -> {write_review}
            menu.choice "View Account Settings", -> {account_settings}
            menu.choice "Exit App", -> {exit_app}
        end
    end

    def account_settings
        system 'clear'
        prompt.select("Hello, #{user.first_name}! Please select from the following options") do |menu|
        menu.choice "Change your FIRST NAME", -> {change_name}
        menu.choice "Change your USERNAME", -> {change_username}
        menu.choice "Update your PASSWORD", -> {change_password}
        menu.choice "View Order History", -> {smell_you_later}
        menu.choice "View your Reviews", -> {view_reviews}
        menu.choice "Delete Account", -> {delete_account}
        menu.choice "Return to Main Menu", -> {main_menu}
        end
    end

    def view_reviews
        if !Review.find_by(user_id: user.id)
            prompt.select("Sorry, #{user.first_name}. It looks like you haven't made any reviews yet. What do you want to do?") do |menu|
            menu.choice "Review an item", -> {write_review}
            menu.choice "View Your Cart", -> {view_cart}
            menu.choice "Return to Account Settings", -> {account_settings}
            menu.choice "Return to Main Menu", -> {main_menu}
            end
        else
            reviews = user.reviews
            puts "Here are all your reviews"
            reviews.each do |review|
                puts "NAME: #{Item.find(review.item_id).name}    TYPE: #{Item.find(review.item_id).alcohol_type}     ORIGIN: #{Item.find(review.item_id).origin}"
                puts "  Your RATING: #{review.rating} ⭐️"
                puts "  Your REVIEW: #{review.review}"
            end
                prompt.select("Would you like to") do |menu|
                menu.choice "Edit a review", -> {edit_from_prev_reviews}
                menu.choice "Return to Account Settings", -> {account_settings}
                menu.choice "Return to Main Menu", -> {main_menu}
                end
        end
    end

    def write_review
        system 'clear'
        prompt.select("Thank you for taking the time to review an item, #{user.first_name}. Would you like to") do |menu|
            menu.choice "Review a spirit from your Order History", -> {review_from_order_history}
            menu.choice "Review additional spirits", -> {review_any_spirit}
            menu.choice "Return to Main Menu", -> {main_menu}
            end
    end

    def review_from_order_history
        system 'clear'
        checked_out_orders = user.orders.where("checked_out = ?", true)
        prev_purchased_items = checked_out_orders.map { |order| order.items }.flatten.uniq.sort_by(&:alcohol_type)
        if !user.orders.find_by(checked_out: true)
            prompt.select("Sorry, #{user.first_name}. It doesn't look like you've made any purchases yet. What would you like to do instead?") do |menu|
            menu.choice "Review additional spirits", -> {review_any_spirit}
            menu.choice "Explore & Shop", -> {buy_alcs}
            menu.choice "Return to Main Menu", -> {main_menu}
            end
        else 
            puts "Below is a list of all spirits from your previous purchases, sorted by TYPE."
            options = prev_purchased_items.map { |item| {"NAME: #{item.name}     TYPE: #{item.alcohol_type}    ORIGIN: #{item.origin}     PRICE: $#{"%.2f" % item.price}    RATING: #{item.rating}" => item.id}}.unshift([{"Return to your cart" => "Return to your cart"}, {"Return to Main Menu" => "Return to Main Menu"}]).flatten
            choice = prompt.select("Please select the item you'd like to REVIEW", options)
                if choice == "Return to your cart"
                    view_cart
                elsif choice == "Return to Main Menu"
                    main_menu
                elsif Review.find_by(user_id: user.id, item_id: choice)
                    prompt.select("Sorry, it looks like you've already left a review for #{Item.find(choice).name}. Would you like to") do |menu|
                    menu.choice "Edit your REVIEW for #{Item.find(choice).name}", -> {edit_review(Item.find(choice))}
                    menu.choice "Review another spirit", -> {write_review}
                    menu.choice "Explore & Shop", -> {buy_alcs}
                    menu.choice "Return to Main Menu", -> {main_menu}
                    end
                else 
                    create_a_rating(Item.find(choice))
                end
        end
    end

    def review_any_spirit
        system 'clear'
            prompt.select("Would you like to") do |menu|
            menu.choice "Review a spirit by NAME", -> {review_by_name}
            menu.choice "Review a spirit by TYPE", -> {review_using_type}
            menu.choice "Return to Main Menu", -> {main_menu}
            end
    end

        def review_by_name
            puts "What is the name of the spirit you'd like to review?"
            answer = gets.chomp 
            alcohols = Item.where("name LIKE ?", "%#{answer}%")
            if Item.find_by("name LIKE ?", "%#{answer}%")
                aoa_alc_info = alcohols.map { |alco| [alco.id, alco.name, alco.price, alco.alcohol_type, alco.origin, alco.rating] } 
                options = aoa_alc_info.map { |arr| {"NAME: #{arr[1]}    PRICE: $#{"%.2f" % arr[2]}    TYPE: #{arr[3]}    ORIGIN: #{arr[4]}     RATING: #{arr[5]}" => arr[0]} } << [{"Try a different name" => "Try a different name"}, {"Search for a spirit to review by TYPE" => "Search for a spirit to review by TYPE"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
                choice = prompt.select("These were the following results we found. Please select a spirit to review", options) 
                if choice == "Try a different name"
                    review_by_name
                elsif choice == "Search for a spirit to review by TYPE"
                    review_using_type
                elsif choice == "Return to Main Menu"
                    main_menu
                elsif Review.find_by(user_id: user.id, item_id: choice)
                    prompt.select("Sorry, it looks like you've already left a review for #{Item.find(choice).name}. Would you like to") do |menu|
                    menu.choice "Edit your review for #{Item.find(choice).name}", -> {edit_review(Item.find(choice))}
                    menu.choice "Review another spirit", -> {write_review}
                    menu.choice "Explore & Shop", -> {buy_alcs}
                    menu.choice "Return to Main Menu", -> {main_menu}
                    end
                else 
                    create_a_rating(Item.find(choice))
                end
            else
                prompt.select("Sorry we couldn't find anything resembling that name. Would you like to:") do |menu|
                    menu.choice "Try a different name", -> {review_by_name}
                    menu.choice "Search for a spirit to review by TYPE", -> {review_using_type}
                    menu.choice "Return to Main Menu", -> {main_menu}
                end
            end
        end
       

        def review_using_type
            choice = prompt.select("What type of spirit is the item you want to review?", Item.all.pluck(:alcohol_type).uniq)
            review_by_type(choice)
        end

            def review_by_type(alc)
                system 'clear'
                alcohols = Item.where("alcohol_type = ?", alc).sort_by(&:origin)
                aoa_alc_info = alcohols.map { |alco| [alco.id, alco.name, alco.price, alco.origin, alco.rating] } 
                options = aoa_alc_info.map { |arr| {"NAME: #{arr[1]}    PRICE: $#{"%.2f" % arr[2]}    ORIGIN: #{arr[3]}     RATING: #{arr[4]}" => arr[0]} }.unshift([{"Return to your cart" => "Return to your cart"}, {"Return to Main Menu" => "Return to Main Menu"}]).flatten
                puts "Below is a list of all #{alc}s, sorted by ORIGIN."
                choice = prompt.select("Please select the spirit you'd like to REVIEW", options)
                    if choice == "Return to your cart"
                        view_cart
                    elsif choice == "Return to Main Menu"
                        main_menu
                    elsif Review.find_by(user_id: user.id, item_id: choice)
                        prompt.select("Sorry, it looks like you've already left a review for #{Item.find(choice).name}. Would you like to") do |menu|
                        menu.choice "Edit your REVIEW for #{Item.find(choice).name}", -> {edit_review(Item.find(choice))}
                        menu.choice "Review another spirit", -> {write_review}
                        menu.choice "Explore & Shop", -> {buy_alcs}
                        menu.choice "Return to Main Menu", -> {main_menu}
                        end
                    else 
                        create_a_rating(Item.find(choice))
                    end
            end

    def create_a_rating(item_inst)
        rat = prompt.slider("How many ⭐️'s would you give #{item_inst.name}     ", min: 0, max: 5, step: 1)
        puts "Please enter a review for #{item_inst.name}"
        rev = gets.chomp
        Review.create(user_id: user.id, item_id: item_inst.id, rating: rat, review: rev)
        system 'clear'
            prompt.select("Thank you for leaving a review for #{item_inst.name}! Would you like to") do |menu|
                menu.choice "Edit your REVIEW for #{item_inst.name}", -> {edit_review(item_inst)}
                menu.choice "Review another spirit", -> {write_review}
                menu.choice "Explore & Shop", -> {buy_alcs}
                menu.choice "Return to Main Menu", -> {main_menu}
            end
    end


    def leave_review(item_inst)
        if Review.find_by(user_id: user.id, item_id: item_inst.id)
            prompt.select("Sorry, it looks like you've already left a review for #{item_inst.name}. Would you like to") do |menu|
            menu.choice "Edit your review for #{item_inst.name}", -> {edit_review(item_inst)}
            menu.choice "Review another spirit", -> {write_review}
            menu.choice "Explore & Shop", -> {buy_alcs}
            menu.choice "Return to Main Menu", -> {main_menu}
            end
        else 
            create_a_rating(item_inst)
        end
    end

    def edit_review(item)
        system 'clear'
        rev = Review.find_by(user_id: user.id, item_id: item.id)
        puts "Here is your current review for #{item.name}:"
        puts "Rating: #{rev.rating} ⭐️"
        puts "Review: #{rev.review}"
        options = [{"Update your REVIEW for #{item.name}" => "Update your REVIEW for #{item.name}"}, {"DELETE your REVIEW for #{item.name}" => "DELETE your REVIEW for #{item.name}"}, {"Return to Main Menu" => "Return to Main Menu"}]
        choice = prompt.select("Would you like to", options) 
            if choice == "Return to Main Menu"
                main_menu
            elsif choice == "DELETE your REVIEW for #{item.name}"
                y_or_n = prompt.select("Are you sure you'd like to DELETE your review for #{item.name}?", ["Yes", "No"])
                    if y_or_n == "Yes"
                        rev.destroy
                        prompt.select("Your REVIEW for #{item.name} has been DELETED. Please select what you'd like to do next") do |menu|
                        menu.choice "Review additional spirits", -> {write_review}
                        menu.choice "Explore & Shop", -> {buy_alcs}
                        menu.choice "Return to Main Menu", -> {main_menu}
                        end
                    else
                        prompt.select("Your REVIEW for #{item.name} WILL NOT be deleted. Please select what you'd like to do next") do |menu|
                        menu.choice "Review additional spirits", -> {write_review}
                        menu.choice "Explore & Shop", -> {buy_alcs}
                        menu.choice "Return to Main Menu", -> {main_menu}
                        end  
                    end 
            else 
                rat = prompt.slider("Please enter your new rating for #{item.name}     ", min: 0, max: 5, step: 1)
                puts "Please enter your new review for #{item.name}"
                desc = gets.chomp
                rev.update(rating: rat, review: desc)

                prompt.select("Thank you, #{user.first_name}. Your REVIEW for #{item.name} has been updated. Please select what you'd like to do next") do |menu|
                menu.choice "Review additional spirits", -> {write_review}
                menu.choice "Explore & Shop", -> {buy_alcs}
                menu.choice "Return to Main Menu", -> {main_menu}
                end
            end
    end

    def edit_from_prev_reviews
        options = user.reviews.map { |review| {Item.find(review.item_id).name => review.item_id} } << [{"Return to Account Settings" => "Return to Account Settings"}, {"Return to Main Menu" => "Return to Main Menu"}].flatten
        choice = prompt.select("Please select the spirit you'd like to EDIT or DELETE your review of", options)
            if choice == "Return to Account Settings"
                account_settings
            elsif choice == "Return to Main Menu"
                main_menu
            else
                edit_review(Item.find(choice))
            end
    end

    def change_password
      system 'clear'
      puts "Happy to help you change your password, #{user.first_name}. Please enter your current PASSWORD"
      answer = gets.chomp

          until answer == user.password do
              puts "Sorry you're entered an incorrect password. Please re-enter your current PASSWORD."
              answer = gets.chomp
          end

      puts "Please enter your new PASSWORD"
      pass_word = gets.chomp 
      
          until pass_word.match?(/^\A\S{5,15}\Z$/) do
              puts "Please enter a PASSWORD 5-15 characters long."
              pass_word = gets.chomp
          end

      puts "Please re-enter your new PASSWORD"
      pass_word2 = gets.chomp
    
        until pass_word == pass_word2 do
            puts "Sorry the passwords did not match. Please enter a PASSWORD."
            pass_word = gets.chomp 
              until pass_word.match?(/^\A\S{5,15}\Z$/) do
                puts "Please enter a PASSWORD 5-15 characters long."
                pass_word = gets.chomp
              end
            puts "Please re-enter your PASSWORD"
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
        puts "Happy to help you change your name in our system. Please enter your FIRST NAME."
        answer = gets.chomp
  
        until answer.match?(/^\A([a-zA-Z]|-){2,30}\Z$/) do
          puts "Please enter your FIRST NAME using only letters or hyphens."
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
        puts "Happy to help you change your username, #{user.first_name}. Please enter your a new USERNAME."
        puts "Enter 5-15 characters using letters, numbers, and underscores(_)"
        answer = gets.chomp

        until answer.match?(/^\A\w{5,15}\Z$/) do
            puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long, using only using letters, numbers, and underscores(_)."
            answer = gets.chomp
        end 

        until !User.find_by(username: answer) do
            puts "Sorry, that username is already taken. Please enter another USERNAME."
            answer = gets.chomp
                if !answer.match?(/^\A\w{5,15}\Z$/) 
                    puts "Sorry, that format was incorrect. Please re-enter a USERNAME 5-15 characters long using only using letters, numbers, and underscores(_)."
                    answer = gets.chomp
                elsif User.find_by(username: answer)
                    puts "Sorry, that username is also taken. Please enter another USERNAME."
                    answer = gets.chomp
                end 
        end
              
        user.update(username: answer)
        prompt.select("Thank you, #{user.first_name}. Your USERNAME has been updated to #{user.username}. Please select what you'd like to do next") do |menu|
          menu.choice "Return to Account Settings", -> {account_settings}
          menu.choice "Explore & Shop", -> {buy_alcs}
          menu.choice "Return to Main Menu", -> {main_menu}
        end
    end

    def delete_account
        system 'clear'
          choice = prompt.select("So sad to see you go! 😭😭💔 Are you sure you want to DELETE your account, #{user.first_name}?", ["Yes", "No"]) 
          
        if choice == "Yes"
            puts "Confirming again that you would like to DELETE your account. All previous order history will no longer be available and the account will be deleted forever."
            answer = prompt.select("Are you sure you want to DELETE your account, #{user.first_name}?", ["Yes", "No"]) 
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
            menu.choice "Search by NAME", -> {search_by_name}
            menu.choice "Search by TYPE", -> {search_by_type}
            menu.choice "Search by ORIGIN", -> {search_by_origin}
            menu.choice "Search by PRICE", -> {search_by_price}
            menu.choice "Search by RATING", -> {search_by_rating}
            menu.choice "View all", -> {view_all}
        end
        
    end

    def search_by_name
        puts "What is the name of the spirit you are looking?"
        answer = gets.chomp 
        alcohols = Item.where("name LIKE ?", "%#{answer}%")
        if Item.find_by("name LIKE ?", "%#{answer}%")
            aoa_alc_info = alcohols.map { |alco| [alco.id, alco.name, alco.price, alco.alcohol_type, alco.origin, alco.rating] } 
            options = aoa_alc_info.map do |arr| 
                {"NAME: #{arr[1]}    PRICE: $#{"%.2f" % arr[2]}    TYPE: #{arr[3]}    ORIGIN: #{arr[4]}     RATING: #{arr[5]}" => arr[0]}
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
                        menu.choice "View REVIEWS for #{item_inst.name}", -> {view_all_reviews(item_inst)}
                        menu.choice "Leave a REVIEW for #{item_inst.name}", -> {leave_review(item_inst)}
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
                            menu.choice "View REVIEWS for #{item_inst.name}", -> {view_all_reviews(item_inst)}
                            menu.choice "Leave a REVIEW for #{item_inst.name}", -> {leave_review(item_inst)}
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
                        menu.choice "View REVIEWS for #{item_inst.name}", -> {view_all_reviews(item_inst)}
                        menu.choice "Leave a REVIEW for #{item_inst.name}", -> {leave_review(item_inst)}
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
                            menu.choice "View REVIEWS for #{item_inst.name}", -> {view_all_reviews(item_inst)}
                            menu.choice "Leave a REVIEW for #{item_inst.name}", -> {leave_review(item_inst)}
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
        choice = prompt.select("Please select a country to see all available spirits.", Item.all.sort_by(&:origin).pluck(:origin).uniq)
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
                        menu.choice "View REVIEWS for #{item_inst.name}", -> {view_all_reviews(item_inst)}
                        menu.choice "Leave a REVIEW for #{item_inst.name}", -> {leave_review(item_inst)}
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
                            menu.choice "View REVIEWS for #{item_inst.name}", -> {view_all_reviews(item_inst)}
                            menu.choice "Leave a REVIEW for #{item_inst.name}", -> {leave_review(item_inst)}
                            menu.choice "View all again", -> {view_all}
                            menu.choice "Explore spirits by a specific criteria", -> {buy_alcs}
                            menu.choice "Return to Main Menu", -> {main_menu}
                        end 
                end
    end

    def view_all_reviews(item)
        system 'clear'
        puts "Here are all the REVIEWS for #{item.name}"
        item.all_reviews
        prompt.select("Would you like to:") do |menu|
            menu.choice "Add #{item.name} to cart", -> {add_to_cart(item)}
            menu.choice "Explore & Shop", -> {buy_alcs}
            menu.choice "Return to Main Menu", -> {main_menu}
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

