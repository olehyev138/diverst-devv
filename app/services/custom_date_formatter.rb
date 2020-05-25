class CustomDateFormatter
    def self.format_date(string)
      if /\d{2}\-\d{2}/ =~ string # if string match format
        # if first 2 less than 12 and last 2 less than 31 just return string
        if string[0, 2].to_i <= 12 && string[3, 2].to_i <= 31
          string
        else
          string = 'Invalid Date'
        end
      elsif /\d{1}\-\d{2}/ =~ string # if string match format
        # if first 2 less than 12 and last 2 less than 31 add 0 to start of string and return string
        if string[0].to_i <= 12 && string[2, 2].to_i <= 31
          string = '0' << string
          string
        else
          string = 'Invalid Date'
        end
      elsif string.scan(/\D/).empty? # if string contains only digits
        if string.length == 4 # format string string when length is 4
          if string[0, 2].to_i <= 12 && string[2, 2].to_i <= 31
            string = string.split('').first(2).join << "-#{string.split('').last(2).join}"
            string = 'Invalid Date'
          end
        elsif string.length == 3 # format string string when length is 3
          if string[0, 2].to_i <= 12 && string[1, 2].to_i <= 31
            string = '0' << string[0] << "-#{string.split('').last(2).join}"
          else
            string = 'Invalid Date'
          end
        else
          string = 'Invalid Date'
        end
      else
        string = 'Invalid Input'
      end
    end
  end
  