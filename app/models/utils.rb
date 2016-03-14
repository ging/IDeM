# encoding: utf-8

class Utils

  #################
  # Languages Utils
  #################

  def self.valid_locale?(locale)
    locale.is_a? String and I18n.available_locales.include? locale.to_sym
  end

  #Translate ISO 639-1 codes to readable language names
  def self.getReadableLanguage(lanCode="")
    I18n.t("languages." + lanCode, :default => lanCode)
  end

end
