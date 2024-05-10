require 'cgi'
require 'net/http'
require 'json'

module Translate
  def self.translate(string, to_lang, from_lang = :auto)
    encode = encode_url(string)
    uri = URI("https://translate.googleapis.com/translate_a/t?client=gtx&sl=#{from_lang}&tl=#{to_lang}&dt=t&q=#{encode}")
    result = net_get(uri)&.first
    from_lang.to_sym == :auto ? result&.first : result
  end

  def self.alternate_translations(string, to_lang, from_lang = :auto)
    uri = URI(url(:at, encode_url(string), from_lang, to_lang))
    result = net_get(uri).dig(5, 0, 2)
    return if result.nil?

    result.map { |arr| arr[0].downcase }.uniq
  end

  def self.definitions(keyword)
    # [ preposition: [desc ex sysnonyms] ]
    uri = URI(url(:md, keyword, :auto))
    result = net_get(uri)[12]
    return if result.nil?

    result.map do |preposition|
      pre = preposition[0]
      {
        "#{pre}": preposition[1].map do |arr|
          code = arr.last
          [arr[0].capitalize, examples(keyword, code)&.first, synonyms(pre, keyword, code)]
        end
      }
    end
  end

  def self.synonyms(pre, keyword, code)
    uri = URI(url(:ss, keyword, :auto))
    result = net_get(uri)[11]
    return if result.nil?

    # rs_response = result.find { |preposition, arr| pre == preposition }
    #                  &.last
    #                  &.map { |arr| arr[0] if arr[1] == code }
    #                  &.compact
    #                  &.join(', ')

    # rs_response unless rs_response.nil? || rs_response.empty?

    rs_response = ''

    result.each do |preposition|
      rs_response = preposition[1].map { |arr| arr[0] if arr[1] == code }.compact.join(', ') if pre == preposition[0]
    end

    rs_response == '' ? nil : rs_response
  end

  def self.examples(keyword, code = nil)
    uri = URI(url(:ex, keyword, :auto))
    result = net_get(uri)[13]
    return unless result

    last_rs = if code.nil?
                result[0].map { |ex| ex[0] }
              else
                result[0].map { |ex| ex[0] if ex.last == code }.compact
              end
    last_rs.map do |ex|
      ex = ex.gsub('<b>', "<b style='color: #ffc017'>").capitalize
      "#{ex}."
    end
  end

  def self.transliteration(string)
    encode = encode_url(string)
    uri = URI(url(:rm, encode, :auto))
    net_get(uri)&.dig(0, 0, 3)
  end

  def self.suggest(string)
    encode = encode_url(string)
    uri = URI(url(:qca, encode, :auto))
    net_get(uri)&.dig(7, 1) || string
  end

  def self.see_more(keyword)
    # ex [kids -> kid, tables -> table]
    encode = encode_url(keyword)
    uri = URI(url(:rw, encode, :auto))
    net_get(uri)&.dig(14, 0, 0) || keyword
  end

  def self.detection(string)
    uri = URI("https://translate.google.com/translate_a/single?client=gtx&sl=auto&q=#{encode_url(string)}")
    response = net_get(uri)
    [response&.dig(2), response&.dig(6)]
  end

  def self.url(dt_value, q_value, from_lang, to_lang = nil)
    "https://translate.googleapis.com/translate_a/single?client=gtx&sl=#{from_lang}&tl=#{to_lang}&dt=#{dt_value}&q=#{q_value}"
  end

  def self.encode_url(string)
    CGI.escape(string)
  end

  def self.net_get(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
    JSON.parse(response.body)
  end
end
