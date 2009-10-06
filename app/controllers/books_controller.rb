class BooksController < ResourceController::Base
  before_filter :save_location
  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :guest_required, :only => [:show, :index, :tagged]
  before_filter :get_tag_data, :only => [:show, :index, :tagged, :search]

  destroy do
    wants.html {redirect_to books_path}
  end


  def show
    @book = @object = Book.find(params[:id])
  end

  def tagged
    @books = @collection = finder_scope.find_tagged_with(tag_selection, :match_all => true)
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

  def search
    @search = params[:search]
    @books = @collection = finder_scope.title_or_notes_or_cached_tag_list_like(@search)
    tags_in_scope
    render :index
  end
  
  private

  def finder_scope
    finder_scope = (logged_in? ? current_user.books : Book)
  end

  def object
    @book ||= @object || current_user.books.find(param)
  end

  def collection
    @books = @collection ||= finder_scope.all
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
