# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  def tag_selected_class(tag_name, selections)
    if selections.include?(tag_name)
      return "tag_selected"
    else
      return ''
    end
  end
end
