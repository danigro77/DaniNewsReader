class ReaderController < ApplicationController
  def home
    @newspapers = Newspaper.all
    @saved_articles = group_articles
    @links = get_articles
  end

  private

  def get_articles
    mechanize = Mechanize.new

    page = mechanize.get('http://derstandard.at/')
    links = page.links_with(href:/^\/\d+\/.+/)
                .reject { |link| link.text.match(/(reuters\/|apa\/|apa \/|foto:|cartoon:)/) }
                .reject { |link| Article.all.pluck(:url).include? link.href }
                .select { |link| link.text.present? && link.href.present? }
                # .inject([]) { |collection, link| collection << {article: {title: link.text, url: link.href}} }
    clean(links)
  end

  def clean(links)
    temp = {}
    result = []
    links.each do |link|
      temp[link.href] ||= []
      temp[link.href] = link.text if temp[link.href].empty? || temp[link.href].length < link.text.length
    end
    temp.each_pair do |url, title|
      result << {article: {title: title, url: url}}
    end
    result
  end

  def group_articles
    grouped = {}
    Article.all.order('created_at desc').group_by(&:created_at).each do |article|
      grouped[article[0].beginning_of_day] ||= []
      grouped[article[0].beginning_of_day] += article[1]
    end
    grouped
  end
end