class Embed < ActiveRecord::Base
  
  #Change URLs to https when clientProtocol is HTTPs
  def self.checkUrlProtocol(url,clientProtocol)
    return url unless url.is_a? String and clientProtocol.include?("https")
    protocolMatch = url.scan(/^https?:\/\//)
    return url if protocolMatch.blank?

    urlProtocol = protocolMatch[0].sub(":\/\/","");
    clientProtocol = clientProtocol.sub(":\/\/","");

    if (urlProtocol != clientProtocol)
      case(clientProtocol)
        when "https"
          #Try to load HTTP url over HTTPs
          url = "https" + url.sub(urlProtocol,""); #replace first
        when "http"
          #Try to load HTTPs url over HTTP. Do nothing.
        else
         #Document is not loaded over HTTP or HTTPs. Do nothing.
        end
    end
    return url
  end

end
