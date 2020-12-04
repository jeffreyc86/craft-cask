require_relative '../config/environment'

application_instance = Application.new
application_instance.welcome

user_or_nil = application_instance.ask_user_for_login_or_register #if login or register is selected

until user_or_nil
    # system "clear"
    user_or_nil = application_instance.ask_user_for_login_or_register
end

# If/ when it exits the until loop, `user_or_nil` is a user_obj
application_instance.user = user_or_nil
# application_instance.main_menu
application_instance.main_menu

