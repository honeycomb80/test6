#this file is designed to scrape TechCrunch pages and create
# Articles, and Wordbanks (words).  It's a beast.

task :tc_scrape => :environment do 
  require 'parsing'
  require 'open-uri'

  # Checks to see if the article has already been included
  def tc_id_check(tc_id)
    Article.find_by(tc_id: tc_id) != nil
  end

  # Gets the articles
  def get_article_data(pg = 2, article_date = Date.today, tc_id = 0)
    agent = Mechanize.new
    tc = agent.get('http://www.techcrunch.com')
    article_pg_count = 0

    # Limits the amount of articles scraped
    until article_date === Date.today - 1  #<-- "yesterday" option

    # until tc_id_check(tc_id) #<-- "all" option
      # Gets the article date
      tc.root.css('li.river-block').each do |link|
        tc_id = link['id'].to_i
        article_date = link.css('time')[0]['datetime']
        article_date = Date.parse(article_date)
        # Gets the author (which isn't always in the same place)
        if link.css('div.byline a').text.empty?
          a = link.css('div.byline').text
          b = link.css('div.byline time').text
          author = a.gsub(b, "")
          author = author.gsub("by", "").strip
        else
          author = link.css('div.byline a').text
        end
      end
      tc.root.css('h2.post-title').each do |this|
        # Gets the link
        link = this.css('a')[0]['href']
        # Gets the headline
        headline = this.css('a')[0].text
        # Makes an article instance
        # Article.create(headline: headline, date: article_date, url: link, author: author, tc_id: tc_id)
        # Creates the mechanize object to the article for scraping later
        m_link = this.css('a')[0]
        url = Mechanize::Page::Link.new(m_link, agent, tc)
        # url = url.click <-- I can use this to change course, scrape articles while crawling
        article_pg_count += 1
        # Gets me to the next page of links
        if article_pg_count == 20
          tc = tc.link_with(:href => %r{page/#{pg}}i).click
          tc
          pg += 1
          article_pg_count = 0
        end
      end
    end
  end

  # Text stripper: I swap a URL for "link" to make it happen
  def get_text(link)
    s_agent = Mechanize.new
    tc_article = s_agent.get(link)
    html_elem = tc_article.at('div.article-entry')
    case html_elem
    when html_elem.css('p').each do |t|
        @article_text = t.text.strip
        puts @article_text
      end
    end
  end

  def already_exist(word)
    Wordbank.find_by(word: word) != nil
  end

  def count_total(array_of_words)
    count = Hash.new(0) 
    array_of_words.each { |word| count[word] += 1 }
  end

  def title_count(array_of_words)
    count = Hash.new(0)
    array_of_words.each { |word| count[word] += 1 }
  end

  # Makes an array into smaller, 2 and 3 word arrays...
  # ...then returns an array of these smaller arrays.
  # It also checks them for punctuation and shortness problems.
  # The first is for article words, the second is for article headlines
  def make_word_phrase(array_of_words)
    array_of_words.each do |word|
      n = array_of_words.index(word)
      # Creates a two word array
      two_word = array_of_words[n..n+1]
      # Checks for the punctuations
      check_two(two_word)
      # Checks for two words
      if two_word[1].nil?
        two_word.clear
      else
        two_word.each do |c|
          # removes unnecessary punctuation
          strip_punct(c)
        end
        if proper_two(two_word)
          two_word = two_word.join(" ")
        else
          two_word = two_word.join(" ")
        end
      end
      # Creates a three word array
      three_word = array_of_words[n..n+2]
      # Checks for the punctuations
      check_three(three_word)
      if three_word[2].nil?
        three_word.clear
      else
        three_word.each do |c|
          strip_punct(c)
        end
        if proper_three(three_word)
          three_word = three_word.join(" ")
        else
          three_word = three_word.join(" ")
        end
      end
    end
  end

  def make_title_phrase(array_of_words)
    array_of_words.each do |word|
      n = array_of_words.index(word)
      # Creates a two word array
      two_word = array_of_words[n..n+1]
      check_two(two_word)
      if two_word[1].nil?
        two_word.clear
      else
        two_word.each do |c|
          strip_punct(c)
        end
        two_word.join(" ")
        Wordbank.create(word: two_word, brand: false, headline: true)
      end
      # creates a three word array
      three_word = array_of_words[n..n+2]
      check_three(three_word)
      if three_word[2].nil?
        three_word.clear
      else
        three_word.each do |c|
          strip_punct(c)
        end
        three_word.join(" ") 
        Wordbank.create(word: three_word, brand: false, headline: true)
      end
    end
  end

end



private
  def article_params
    params.require(:article).permit(:headline, :date, :url, :author)
  end

  def wordbank_params
    params.require(:wordbank).permit(:word, :brand, :headline)
  end

  def count_params
    param.require(:count).permit(:qty, :wordbank_id, :article_id)
  end

