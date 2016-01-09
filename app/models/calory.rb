class Calory < ActiveRecord::Base
  belongs_to :user

  # e.g. Calory.filter_by_date_hour('2016-01-09', 1, '2016-02-02', 2)
  def self.filter_by_date_hour(date_from, hour_from, date_to, hour_to)
    df = date_from.split('-').map {|x| x.to_i}
    dt = date_to.split('-').map {|x| x.to_i}
    from = Time.new(df[0], df[1], df[2], hour_from.to_i, 0)
    to = Time.new(dt[0], dt[1], dt[2], hour_to.to_i, 0)
    where('created_at BETWEEN ? AND ?', from, to)
  end
end
