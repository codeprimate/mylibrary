class BooksController < ResourceController::Base
  before_filter :save_location
  before_filter :login_required

  destroy do
    wants.html {redirect_to books_path}
  end

  private

  def object
    @book ||= @object || current_user.books.find(param)
  end

  def collection
    @books ||= @collection = current_user.books
  end

  def build_object
    @object ||= current_user.books.build(params[:book])
  end
end
