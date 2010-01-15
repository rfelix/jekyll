module Jekyll

  module Filters
    def textilize(input)
      RedCloth.new(input).to_html
    end

    def date_to_string(date)
      date.strftime("%d %b %Y")
    end

    def date_to_long_string(date)
      date.strftime("%d %B %Y")
    end

    def date_to_xmlschema(date)
      date.xmlschema
    end

    def xml_escape(input)
      CGI.escapeHTML(input)
    end

    def cgi_escape(input)
      CGI::escape(input)
    end

    def number_of_words(input)
      input.split.length
    end

    def array_to_sentence_string(array)
      connector = "and"
      case array.length
      when 0
        ""
      when 1
        array[0].to_s
      when 2
        "#{array[0]} #{connector} #{array[1]}"
      else
        "#{array[0...-1].join(', ')}, #{connector} #{array[-1]}"
      end
    end
    
    def shorten(string, word_count)
      words = string.split(' ')
      return string if string.length <= word_count
      
      count = words.length - 1 # number of spaces
      count += 3 # for "..."
      start_i, end_i = 0, words.length - 1
      prefix, suffix = [], []
      while count <= word_count
        [start_i, end_i].each_with_index do |i, pos|
          if words[i].length + count <= word_count
            if pos == 0
              prefix
            else
              suffix
            end << words[i]
            count += words[i].length
          end
        end
        start_i += 1
        end_i -= 1
        break if start_i >= end_i
      end
      "#{prefix.join(' ')}...#{suffix.reverse.join(' ')}"
    end

    def to_month(input)
      return Date::MONTHNAMES[input.to_i]
    end

    def to_month_abbr(input)
      return Date::ABBR_MONTHNAMES[input.to_i]
    end
  end
end
