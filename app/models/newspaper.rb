class Newspaper < ActiveRecord::Base
  has_many :articles

  KNOWN_LINK_TYPES = %w(full partial).freeze
  KNOWN_CHARACTERISITCS = %w(num_front num_end default).freeze

  SCRAPE_HELPER = {
      full: {
          default: /^https?:\/\/.+/
      },
      partial: {
          num_front: /^\/\d+\/.+/,
          num_end: /^\/.+\/.*\d+$/
      }
  }

  before_save :check_url

  validate :valid_link_type, :valid_link_characteristic
  validates_presence_of :url, :name, :link_type

  def scrape_page
    mechanize = Mechanize.new

    page = mechanize.get(url)
    links = get_links(page)
    clean(link_scraping(links)) if links.present?
  end

  private

  def clean(articles)
    temp = {}
    result = []
    articles.each do |article|
      link = {
          text: article.text,
          href: article.href
      }
      next unless link[:text].present? && link[:href].present?
      temp[link[:href]] ||= []
      temp[link[:href]] = link[:text] if temp[link[:href]].empty? || temp[link[:href]].length < link[:text].length
    end
    temp.each_pair do |url, title|
      result << {title: title, url: url, newspaper_id: self.id}
    end
    result
  end

  def link_scraping(links)
    links.reject { |link| link.text.match(/(reuters\/|apa\/|apa \/|foto:|cartoon:)/) }
        .select { |link| link.text.present? && link.href.present? }
  end

  def get_links(page)
    page.links_with(href: SCRAPE_HELPER[link_type.to_sym][link_characteristic.to_sym])
  end

  def valid_link_type
    unless KNOWN_LINK_TYPES.include? link_type
      errors.add(:link_type, "is unknown.")
    end
  end

  def valid_link_characteristic
    if link_characteristic && KNOWN_CHARACTERISITCS.exclude?(link_characteristic)
      errors.add(:link_characteristic, "is unknown.")
    end
  end

  def check_url
    if url.match(/\/$/)
      self.url = url[0..-2]
      unless self.save
        errors.add(:url, "could not be cleaned.")
      end
    end
  end
end