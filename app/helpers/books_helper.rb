module BooksHelper

  def tag_list_for(book)
    (book.tags.map{|tag| link_to((h(tag.name)), '#')}||'none').join(', ')
  end
end
