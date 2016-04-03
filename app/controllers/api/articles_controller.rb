class Api::ArticlesController < ApplicationController
  respond_to :json

  def articles
    result = saved_articles
    respond_with result
  end

  def frontpage_headlines
    mechanize = Mechanize.new

    page = mechanize.get('http://derstandard.at/')
    links = page.links_with(href:/^\/\d+\/.+/)
                .reject { |link| link.text.match(/(reuters\/|apa\/|apa \/|foto:|cartoon:)/) }
                .select { |link| link.text.present? && link.href.present? }
    respond_with clean(links), location: '/'
  end

  def save_article
    article = Article.new(article_params)
    if article.save
      respond_with saved_articles, location: '/'
    else
      render json: article.errors, status: 404
    end
  end

  def delete
    article = Article.find(params[:id])
    if article.delete
      respond_with saved_articles, location: '/'
    else
      render json: article.errors, status: 404
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :url)
  end

  def saved_articles
    articles = Article.all
    {
        existing_urls: articles.pluck(:url),
        saved: group(articles)
    }
  end

  def clean(links)
    temp = {}
    result = []
    links.each do |link|
      temp[link.href] ||= []
      temp[link.href] = link.text if temp[link.href].empty? || temp[link.href].length < link.text.length
    end
    temp.each_pair do |url, title|
      result << {title: title, url: url}
    end
    result
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