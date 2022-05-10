require 'watir'
require 'webdrivers'
require 'nokogiri'
require 'csv'
require 'byebug'
require 'active_support'
# require 'mechanize'


#Use debugger if you want to do script one line at a time, for example if captcha needs to be done you can do that manually
#byebug

# Starts Browser instance
browser = Watir::Browser.new
# browser.goto 'https://blog.eatthismuch.com/latest-articles/'

#Goes through a login process this can also be done manually as long as browser is open
browser.goto 'http://www.example.com'
browser.text_field(id: 'email').set 'sample@gmail.com'
browser.button(class: 'class_name').click
browser.text_field(id: 'password').set 'sample'
browser.button(class: 'class_name').click


#Parse html page that will be used to scrape data
parsed_page = Nokogiri::HTML(browser.html)
# parsed_page = File.open("parsed_2.html") { |f| Nokogiri::HTML(f) }
File.open("parsed_2.html", "w") { |f| f.write "#{parsed_page}" }

#close browser we have already collected html
browser.close

#Create new CSV file and push arrays of data into file in order to create readable data
CSV.open("comments_NYT_two.csv", "a+") do |csv|
    #CSV headers
    csv << ["User", "Location", "Date", "Comment"]
    
    article_cards = parsed_page.xpath("//div[contains(@class, 'css-aa7djq')]")

    article_cards.each do |card|

        user = card.xpath("div[@class='css-qm7y3c']//div[@class='css-1vg6q84']").text
        location = card.xpath("div[@class='css-qm7y3c']//div[@class='css-wd09rn']/span/span").text
        date = card.xpath("div[@class='css-qm7y3c']//div[@class='css-wd09rn']/span/a").text
        comment = card.xpath("div[@class='css-199z855']").text

        csv << [user, location, date, comment]
    end
end