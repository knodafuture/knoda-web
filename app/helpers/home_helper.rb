module HomeHelper
  def splitFade(text)
    tokens = text.split ' '
    if tokens.size >= 3
      averageSpanLength = tokens.size / 3
    else
      averageSpanLength = tokens.size
    end
    fadeTimes = ['fade0','fade100', 'fade300', 'fade500']
    out = "<span class=#{fadeTimes[rand(4)]}>"
    i = 0
    tokens.each do |t|
      out << "#{t} "
      i = i + 1
      if (i == tokens.size)
        out << '</span>'
      elsif (i % averageSpanLength == 0)
        out << "</span><span class=#{fadeTimes[rand(4)]}>" 
      end
    end
    return out
  end
end
