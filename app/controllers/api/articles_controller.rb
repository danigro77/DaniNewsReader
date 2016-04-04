class Api::ArticlesController < ApplicationController
  respond_to :json

  def articles
    respond_with saved_articles(params[:newspaper_id])
  end

  def frontpage_headlines
    newspaper = Newspaper.find(params[:newspaper_id])
    respond_with newspaper.scrape_page, location: '/'
  end

  def save_article
    article = Article.new(article_params)
    article.users << current_user
    if article.save
      respond_with saved_articles(article.newspaper_id), location: '/'
    else
      render json: article.errors, status: 404
    end
  end

  def delete
    article = Article.find(params[:id])
    if article.delete
      render nothing:true, status: 204
    else
      render json: article.errors, status: 404
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :url, :newspaper_id)
  end

  def saved_articles(newspaper_id)
    articles = current_user.articles.where(newspaper_id: newspaper_id)
    {
        existing_urls: articles.pluck(:url),
        saved: group(articles)
    }
  end

  def group(articles)
    grouped = {}
    articles.order('created_at desc').group_by(&:created_at).each do |article|
      grouped[article[0].beginning_of_day.strftime("%d %^b %Y")] ||= []
      grouped[article[0].beginning_of_day.strftime("%d %^b %Y")] += article[1]
    end
    grouped
  end
end