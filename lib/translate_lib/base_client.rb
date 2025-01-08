require 'net/http'
require 'json'

module TranslateLib
  class BaseClient
    CLIENT = 'gtx'.freeze
    COMMON_TYPE = 'translate_a/single'.freeze
    TRANSLATE_TYPE = 'translate_a/t'.freeze
    BASE_URL = 'https://translate.googleapis.com'.freeze

    def translate_uri(**args)
      URI("#{BASE_URL}/#{args[:type]}?client=#{CLIENT}&sl=#{args[:sl]}&tl=#{args[:tl]}&dt=#{args[:dt]}&q=#{args[:q]}")
    end

    def get(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      JSON.parse(response.body)
    rescue StandardError => e
      raise StandardError, e.message
    end
  end
end
