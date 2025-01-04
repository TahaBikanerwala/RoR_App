module ApplicationHelper
  # returns title per page basis
  def full_title(page_title = "")
    base_title = "Ruby on Rails Sample App"
    if page_title.empty?
      base_title
    else
      # this creates issues with escape characters
      # "#{page_title} | #{base_title}"
      page_title + " | " + base_title
    end
  end
end
