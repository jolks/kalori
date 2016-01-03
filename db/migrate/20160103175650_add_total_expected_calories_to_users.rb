class AddTotalExpectedCaloriesToUsers < ActiveRecord::Migration
  def change
    # http://healthyeating.sfgate.com/average-calorie-intake-human-per-day-versus-recommendation-1867.html
    add_column :users, :total_expected_calories, :integer, default: 2000
  end
end
