require 'cgi'
require_relative 'base_client'
require_relative 'validation'

module TranslateLib
  class Translator < BaseClient
    def translate(string, to_lang, from_lang = :auto)
      Validation.validate_language_code(from_lang, to_lang)
      encode = encode_url(string)
      uri = translate_uri(type: TRANSLATE_TYPE, sl: from_lang, tl: to_lang, dt: :t, q: encode)
      result = get(uri)&.first
      from_lang.to_sym == :auto ? result&.first : result
    end

    def alternate_translations(string, to_lang, from_lang = :auto)
      Validation.validate_language_code(from_lang, to_lang)
      uri = translate_uri(type: COMMON_TYPE, sl: from_lang, tl: to_lang, dt: :at, q: encode_url(string))
      result = get(uri).dig(5, 0, 2)
      return if result.nil?

      result.map { |arr| arr[0].downcase }.uniq
    end

    def definitions(keyword)
      Validation.validate_keyword(keyword)
      uri = translate_uri(type: COMMON_TYPE, sl: :auto, tl: :auto, dt: :md, q: keyword)
      result = get(uri)[12]
      return if result.nil?

      result.map do |preposition|
        pre = preposition[0]
        {
          "#{pre}": preposition[1].map do |arr|
            code = arr.last
            [arr[0], examples(keyword, code)&.first, synonyms(pre, keyword, code)]
          end
        }
      end
    end

    def synonyms(pre, keyword, code)
      uri = translate_uri(type: COMMON_TYPE, sl: :auto, tl: :auto, dt: :ss, q: keyword)
      result = get(uri)[11]
      return if result.nil?

      rs_response = ''

      result.each do |preposition|
        rs_response = preposition[1].map { |arr| arr[0] if arr[1] == code }.compact.join(', ') if pre == preposition[0]
      end

      rs_response == '' ? nil : rs_response
    end

    def examples(keyword, code = nil)
      Validation.validate_keyword(keyword)
      uri = translate_uri(type: COMMON_TYPE, sl: :auto, tl: :auto, dt: :ex, q: keyword)
      result = get(uri)[13]
      return unless result

      last_rs = if code.nil?
                  result[0].map { |ex| ex[0] }
                else
                  result[0].map { |ex| ex[0] if ex.last == code }.compact
                end
      last_rs.map do |ex|
        "#{ex}."
      end
    end

    def transliteration(keyword)
      Validation.validate_keyword(keyword)
      uri = translate_uri(type: COMMON_TYPE, sl: :auto, tl: :auto, dt: :rm, q: keyword)
      get(uri)&.dig(0, 0, 3)
    end

    def suggest(string)
      encode = encode_url(string)
      uri = translate_uri(type: COMMON_TYPE, sl: detection(string).first, tl: detection(string).first == 'en' ? :vi : :en, dt: :qca, q: encode)
      get(uri)&.dig(7, 1) || string
    end

    def see_more(keyword)
      Validation.validate_keyword(keyword)
      uri = translate_uri(type: COMMON_TYPE, sl: :auto, tl: :auto, dt: :rw, q: keyword)
      get(uri)&.dig(14, 0, 0) || keyword
    end

    def detection(string)
      uri = translate_uri(type: COMMON_TYPE, sl: :auto, tl: :auto, dt: :rm, q: encode_url(string))
      response = get(uri)
      [response&.dig(2), response&.dig(6)]
    end

    private

    def encode_url(string)
      Validation.validate_string(string)
      CGI.escape(string)
    end
  end
end
