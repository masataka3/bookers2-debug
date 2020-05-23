class BookCommentsController < ApplicationController
	def create
		@book = Book.find(params[:book_id])
		@book_comment = current_user.book_comments.new(book_comment_params)
		@book_comment.book_id = @book.id
		@user = User.find_by(id: @book.user_id)
		@book_comment.save
	end

	def destroy
		

		   # WARNING: book_id となっているがbook_commentのid
    	   comment = BookComment.find(params[:comment_id].to_i)

    	   @book = comment.book
    	   if comment.destroy
    	   end
    	   # redirect_to "/books/#{comment.book.id}}"
    	   # redirect_to book_path(comment.book.id)
    	   # redirect_to book_path(@book.user_id)
    end
    def set_comment
    	@comment = Comment.find_by(id: params[:id])

    end

private
    def book_comment_params
		params.require(:book_comment).permit(:comment)
	end
end
