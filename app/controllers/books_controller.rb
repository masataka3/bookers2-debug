class BooksController < ApplicationController
    before_action :authenticate_user!
  def show
  	@book = Book.find(params[:id])
    @user = User.find_by(id: @book.user_id)
    @book_comment = BookComment.new
    @book_comments = @book.book_comments
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book = Book.new
  end

  def create
    @books = Book.all
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to book_path(@book), notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
  		@books = Book.all
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
     if @book.user.id != current_user.id
      redirect_to books_path
    end
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to book_path(@book), notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render :edit
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

   def already_favorited?(user) #いいねしているかどうか
    favorites.where(user_id: user.id).exists?
  end

  def fav
    book = Book.find(params[:id])
    if book.favorited_by?(current_user)
       fav = current_user.favorites.find_by(book_id: book.id)
      fav.destroy
      render json: book.id
    else
      fav = current_user.favorites.new(book_id: book.id)
      fav.save
      render json: book.id
    end
  end

  private

  def book_params
  	params.require(:book).permit(:title,:body)
  end

end
