class ArticlesController < ApplicationController

  def save_article
    @article = Article.new(article_params)
    if @article.save
      redirect_to '/', notice: 'Article saved for later reading.'
    else
      redirect_to '/', warn: 'Article was not saved. Please try again.'
    end
  end

  def delete
    article = Article.find(params[:id])
    if article.delete
      redirect_to '/', notice: 'Article removed from reading list.'
    else
      redirect_to '/', warn: 'Article could not be removed from reading list. Please try again later.'
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :url)
  end
end