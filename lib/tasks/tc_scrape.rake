#this file 

require "nokogiri"
require "mechanize"
require "open-uri"

task :tc_scrape => :environment do 

  # this checks to see if the article has already been included
  def tc_id_check(tc_id)
    Article.find_by(tc_id: tc_id) != nil
  end

  # this gets the articles
  def get_article_data(pg = 2, article_date = Date.today)
    agent = Mechanize.new
    tc = agent.get('http://www.techcrunch.com')
    article_pg_count = 0

    until article_date === Date.today - 1
      # this gets the article date
      tc.root.css('li.river-block').each do |link|
        tc_id = link['id']
        article_date = link.css('time')[0]['datetime']
        article_date = Date.parse(article_date)
        # this gets the author
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
        # this gets the link
        link  =  this.css('a')[0]['href']
        # this gets the title
        title  =  this.css('a')[0].text
        # this makes an article instance
        Article.create(title: title, date: article_date, url: link, author: author, tc_id: tc_id)
        # this creates the mechanize object to the article for scraping later
        m_link =  this.css('a')[0]
        url = Mechanize::Page::Link.new(m_link, agent, tc)
        # url = url.click <-- I can use this to change course, scrape articles while crawling
        article_pg_count += 1
        # this gets me to the next page of links
        if article_pg_count == 20
          tc = tc.link_with(:href => %r{page/#{pg}}i).click
          tc
          pg += 1
          article_pg_count = 0
        end
      end
    end
  end

  # text stripper: I swap a URL for "link" to make it happen
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

  # these check fronts, backs of words for quotes
  def fr_quotes(word)
    /\A\"|\'/.match(word) != nil
  end

  def bk_quotes(word)
    /\Z\"|\'/.match(word) != nil
  end

  # these check fronts, backs of word for parentheses
  def fr_parens(word)
    /\A\(|\{|\</.match(word) != nil
  end

  def bk_parens(word)
    /\Z\)|\}|\>/.match(word) != nil
  end

  # these check fronts, backs of words for other punctuation
  def check_fr(word)
    /\A\,|\?|\!\+/.match(word) != nil
  end

  def check_bk(word)
    /\Z\,|\?|\!|\./.match(word) != nil
  end

  # this checks to see if it's a proper noun (to denote as brand)
  def proper(word)
    /[[:upper:]]/.match(word) != nil
  end

  def proper_two(array)
    one   = array[0]
    two   = array[1]
    if proper(one) && proper(two)
      true
    else
      false
    end
  end

  def proper_three(array)
    one   = array[0]
    two   = array[1]
    three = array[2]
    if proper(one) && proper(two) && proper(three)
      true
    else
      false
    end
  end

  # this checks a two-word array for punctuation problems
  def check_two(array)
    one   = array[0]
    two   = array[1]
    if bk_quotes(one) || bk_parens(one) || check_bk(one) || fr_parens(two) || fr_quotes(two)
      array.clear
    end
  end

  # this checks a three-word array for punctuation problems
  def check_three(array)
    one   = array[0]
    two   = array[1]
    three = array[2]
    if bk_quotes(one) || bk_parens(one) || check_bk(one) || fr_parens(two) || fr_quotes(two)
      array.clear
    elsif bk_quotes(two) || bk_parens(two) || check_bk(two) || fr_parens(three) || fr_quotes(three)
      array.clear
    end
  end

  # this checks to see if it's google+
  def google_plus(word)
    if /\Z+/.match(word) != nil && /google/i.match(word) != nil
      true
    else
      false
    end
  end

  def strip_punct(word)
    # this strips most types of punctuation from the front of the word
    if /\A\W/.match(word) != nil
      unless /\A\.|\@|\#|\$/.match(word) != nil
      word.gsub!(/\A\W/, "")
      end
    end
    # this strips all types of punctuation from the end of the word, except Google+
    if /\W\Z/.match(word) != nil
      unless google_plus(word)
      word.gsub!(/\W\Z/, "")
      end
    end
  end

  # this makes an array into smaller, 2 and 3 word arrays...
  # ...then returns an array of these smaller arrays.
  # It also checks them for punctuation and shortness problems.
  def make_word_phrase(array)
    array.each do |word|
      n = array.index(word)
      # creates a two word array
      two_word = array[n..n+1]
      check_two(two_word)
      if two_word[1].nil?
        two_word.clear
      else
        two_word.each do |c|
          strip_punct(c)
        end
        if proper_two(two_word)
          two_word.join(" ")
          Wordbank.create(word: two_word, brand: true, headline: false)
        else
          two_word.join(" ")
          Wordbank.create(word: two_word, brand: false, headline: false)
        end
      end
      # creates a three word array
      three_word = array[n..n+2]
      check_three(three_word)
      if three_word[2].nil?
        three_word.clear
      else
        three_word.each do |c|
          strip_punct(c)
        end
        if proper_three(three_word)
          three_word.join(" ")
          Wordbank.create(word: three_word, brand: true, headline: false)
        else
          three_word.join(" ")
          Wordbank.create(word: three_word, brand: false, headline: false)
        end
      end
    end
  end

  def make_title_phrase(array)
    array.each do |word|
      n = array.index(word)
      # creates a two word array
      two_word = array[n..n+1]
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
      three_word = array[n..n+2]
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

