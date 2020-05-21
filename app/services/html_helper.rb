class HtmlHelper
  def self.html_truncate(html, limit)
    tags = []
    count = 0
    itr = 0
    trunc_html = ''
    counting = true
    while count < limit && itr < html.length
      if html[itr] == '<'
        counting = false
        trunc_html += '<'
        itr += 1
        if html[itr..itr + 1] == 'br' || html[itr..itr + 2] == 'img'
        elsif html[itr] == '/'
          tags.pop
        else
          tag_type = ''
          while html[itr] != ' ' && html[itr] != '>'
            trunc_html += html[itr]
            tag_type += html[itr]
            itr += 1
          end
          tags.push("</#{tag_type}>")
        end
      else
        trunc_html += html[itr]
        count += 1 if counting && html[itr] != '\n'
        counting = true if html[itr] == '>'
        itr += 1
      end
    end
    trunc_html += '...' if count >= limit
    while tags.present?
      trunc_html += tags.pop
    end
    trunc_html
  end

  def self.strip_truncate(html, limit)
    count = 0
    itr = 0
    trunc_html = ''
    counting = true
    while count < limit && itr < html.length
      if html[itr] == '<'
        counting = false
      else
        trunc_html += html[itr] if counting
        count += 1 if counting && html[itr] != '\n'
        counting = true if html[itr] == '>'
      end
      itr += 1
    end
    trunc_html += '...' if count >= limit
    trunc_html
  end

  def self.to_pain_text(html)
    html = html.gsub(/<br.*>/, "\n")
    html = html.gsub("\r\n\r\n", "\n")

    html = html.gsub('&nbsp;', ' ')
    html = html.gsub('&#39;', '\'')

    html = html.gsub(/<.*?>/, '')
    html
  end

  def self.to_mrkdwn(html)
    html = html.gsub(/<p.*?>/, '')
    html = html.gsub('</p>', '')

    html = html.gsub('<strong>', '*')
    html = html.gsub('</strong>', '*')

    html = html.gsub('<em>', '_')
    html = html.gsub('</em>', '_')

    html = html.gsub('<s>', '~')
    html = html.gsub('</s>', '~')

    html = html.gsub('<u>', '')
    html = html.gsub('</u>', '')

    html = html.gsub('&nbsp;', ' ')
    html = html.gsub('&#39;', '\'')

    # <a href="http://youtube.com">YOUTUBE LINK</a>
    html = html.gsub(/<a href="(.*)">(.*)<\/a>/, '<\1|\2>')

    html = html.gsub(/<br.*>/, "\n")
    html = html.gsub("\r\n\r\n", "\n")
    html = html.gsub("\r\n", "\n")
    html = html.gsub("\t", '')

    in_bullet = false
    in_list = false
    in_quote = false
    in_tag = false
    in_list_element = false
    list_count = 1

    new = ''

    (0...html.length).each do |i|
      if html[i] == '<'
        link_substring = html[i..-1][/\A<[^>]*?\|[^<]*?>/]
        new.concat link_substring unless link_substring.nil?
        in_tag = true
        if html[i..i + 3] == '<ul>'
          in_bullet = true
        elsif html[i..i + 4] == '</ul>'
          in_bullet = false
        elsif html[i..i + 3] == '<ol>'
          in_list = true
          list_count = 1
        elsif html[i..i + 4] == '</ol>'
          in_list = false
        elsif html[i..i + 3] == '<li>'
          new.concat("\t- ") if in_bullet
          new.concat("\t#{list_count}. ") if in_list
          list_count += 1
        elsif html[i..i + 4] == '</li>'
          new.concat("\n")
        elsif html[i..i + 11] == '<blockquote>'
          in_quote = true
        elsif html[i..i + 12] == '</blockquote>'
          in_quote = false
        end
      end
      if html[i] == '>'
        in_tag = false
        next
      end
      unless html[i] =~ /[\n\t\r]/ && (in_list || in_bullet)
        new.concat html[i] unless in_tag
      end
      if html[i] == "\n"
        new.concat '>' if in_quote && html[i + 1..i + 13] != '</blockquote>'
      end
    end

    new
  end
end
