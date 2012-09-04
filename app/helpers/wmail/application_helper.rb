module Wmail
  module ApplicationHelper
    def format_date(date1)
      current_time = DateTime.parse(Time.now.to_s)
      current_date = current_time.to_date
      given_time = DateTime.parse(date1)
      given_date = given_time.to_date

      if current_date == given_date
        given_time.strftime("%l:%M %p")
      elsif given_time.year == current_time.year
        given_time.strftime("%b %-d")
      else
        given_time.strftime("%m/%d/%C")
      end
    end
  end
end
