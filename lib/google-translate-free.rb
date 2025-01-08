require 'cgi'
require 'net/http'
require 'json'
require_relative 'translate_lib/translator'
require_relative 'translate_lib/validation'

module Translate
  def self.translate(string, to_lang, from_lang = :auto)
    translator = TranslateLib::Translator.new
    translator.translate(string, to_lang, from_lang)
  end

  def self.alternate_translations(string, to_lang, from_lang = :auto)
    translator = TranslateLib::Translator.new
    translator.alternate_translations(string, to_lang, from_lang)
  end

  def self.definitions(keyword)
    translator = TranslateLib::Translator.new
    translator.definitions(keyword)
  end

  def self.synonyms(pre, keyword, code)
    translator = TranslateLib::Translator.new
    translator.synonyms(pre, keyword, code)
  end

  def self.examples(keyword, code = nil)
    translator = TranslateLib::Translator.new
    translator.examples(keyword, code)
  end

  def self.transliteration(keyword)
    translator = TranslateLib::Translator.new
    translator.transliteration(keyword)
  end

  def self.suggest(string)
    translator = TranslateLib::Translator.new
    translator.suggest(string)
  end

  def self.see_more(keyword)
    translator = TranslateLib::Translator.new
    translator.see_more(keyword)
  end

  def self.detection(string)
    translator = TranslateLib::Translator.new
    translator.detection(string)
  end
end
