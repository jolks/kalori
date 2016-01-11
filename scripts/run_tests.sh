# Unit tests
rake test test/models/user_test.rb
rake test test/models/calorie_test.rb

# Functional tests
rake test test/controllers/users_controller_test.rb
rake test test/controllers/sessions_controller_test.rb
rake test test/controllers/calories_controller_test.rb

# Integration tests
rake test test/integration/user_flows_test.rb
