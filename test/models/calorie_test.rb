require 'test_helper'

class CalorieTest < ActiveSupport::TestCase
  test "count calories created from fixtures" do
    assert_equal 4, Calory.count
  end

  test "filter_by_date_hour method works" do
    assert_equal 2, Calory.filter_by_date_hour('2016-01-01', 12, '2016-01-01', 18).count
  end
end
