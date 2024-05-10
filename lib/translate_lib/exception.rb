module TranslateLib
  class Exception < StandardError
    def self.raise_error!(message)
      raise self, message
    end
  end
end
