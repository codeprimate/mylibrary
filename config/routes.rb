ActionController::Routing::Routes.draw do |map|
  map.root :controller => "user_sessions", :action => 'new'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  map.resources :user_sessions
  map.resources :users
  map.clear_book_tags '/books/clear_tag_selection', :controller => "books", :action => "clear_tag_selection"
  map.formatted_clear_book_tags '/books/clear_tag_selection.:format', :controller => "books", :action => "clear_tag_selection"
  map.tagged_books '/books/tagged/:tag', :controller => "books", :action => "tagged", :conditions => {:method => :get}
  map.search_books '/books/search', :controller => 'books', :action => 'search', :conditions => {:method => :post}
  map.resources :books


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
