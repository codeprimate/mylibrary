class BooksController < ResourceController::Base
  before_filter :save_location
  before_filter :guest_authorization
  before_filter :login_required, :only => [:new, :edit, :update, :destroy]
  before_filter :get_tag_data

  destroy do
    wants.html {redirect_to books_path}
  end


  def show
     @book = @object = Book.find(params[:id])
  end

  def tagged
    @books = @collecton = current_user.books.find_tagged_with(tag_selection)
    tags_in_scope
    render :index
  end

  def clear_tag_selection
    @tag_selection = session[:tag_selection] = nil
    respond_to do |format|
      format.js
      format.html { redirect_to books_path}
    end
  end
  
  private

  def object
    @book ||= @object || current_user.books.find(param)
  end

  def collection
    if logged_in?
      @books ||= @collection = current_user.books
    else
      @books ||= @collection = Book.all
    end
    tags_in_scope
    return @collection
  end

  def tag_selection
    unless @tag_selection
      session[:tag_selection] ||= []
      session[:tag_selection] << params[:tag] if params[:tag]
      @tag_selection = session[:tag_selection]
    end
    return @tag_selection
  end

  def reset_tag_selection
    @tag_selection = session[:tag_selection] = []
  end

  def tags_in_scope
    @tags = ((@collection || []).empty? ? Tag.find_all_by_name(tag_selection).map(&:name) : @collection.collect{|book| book.tags.map(&:name)}).flatten.compact.uniq.sort
  end

  def get_tag_data
    tag_selection
    tags_in_scope
  end

  def build_object
    @object ||= current_user.books.build(params[:book])
  end
end
