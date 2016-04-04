# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

newspapers = [
    {
        name: 'Der Standard',
        link_type: 'partial',
        link_characteristic: 'num_front',
        url: 'http://derstandard.at',
        language: 'de'
    },
    {
        name: 'CNN',
        link_type: 'partial',
        link_characteristic: 'num_front',
        url: 'http://www.cnn.com',
        language: 'en'
    },
    {
        name: 'BBC',
        link_type: 'partial',
        link_characteristic: 'num_end',
        url: 'http://www.bbc.com',
        language: 'en'
    },
    {
        name: 'Hacker News',
        link_type: 'full',
        link_characteristic: '',
        url: 'https://news.ycombinator.com',
        language: 'en'
    }
]

newspapers.each do |paper|
  Newspaper.find_or_create_by(paper)
end
