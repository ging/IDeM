module PresentationHelper
  
  def presentation_raw_thumbail(presentation)
    Embed.checkUrlProtocol(presentation.thumbnail_url,request.protocol) || "/assets/logos/original/excursion-00.png"
  end

end