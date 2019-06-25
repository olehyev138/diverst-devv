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
end
