# encoding: utf-8

class Utils

  #################
  # Languages Utils
  #################

  def self.valid_locale?(locale)
    locale.is_a? String and I18n.available_locales.include? locale.to_sym
  end

  def self.getAllLanguages
    I18n.available_locales.map{|l| l.to_s}
  end

  #Translate ISO 639-1 codes to readable language names
  def self.getReadableLanguage(lanCode="")
    I18n.t("languages." + lanCode.to_s, :default => lanCode.to_s)
  end

end
