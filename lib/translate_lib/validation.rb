require_relative 'exception'

module TranslateLib
  class Validation
    ALLOW_LANGUAGE_CODE = %w[
      auto
      af sq am ar hy as ay az bm eu be bn bho bs
      bg ca ceb zh-cn zh-tw zh co hr cs da dv doi nl en
      eo et ee fil fi fr fy gl ka de el gn gu ht
      ha haw he hi hmn hu is ig ilo id ga it ja jv jw
      kn kk km rw gom ko kri ku ckb ky lo la lv ln
      lt lg lb mk mai mg ms ml mt mi mr mni-mtei lus
      mn my ne no ny or om ps fa pl pt pa qu ro ru
      sm sa gd nso sr st sn sd si sk sl so es su sw
      sv tl tg ta tt te th ti ts tr tk ak uk ur ug
      uz vi cy xh yi yo zu
    ].freeze

    def self.validate_string(string)
      raise_error!('Translate strings shorter than or equal to 5000 characters.') if string.length > 5000
    end

    def self.validate_keyword(keyword)
      raise_error!('keyword does not have a valid value.') unless single_word?(keyword)
    end

    def self.validate_language_code(from_lang, to_lang)
      raise_error!('from_lang does not have a valid value.') unless ALLOW_LANGUAGE_CODE.include?(from_lang.to_s.downcase)
      raise_error!('to_lang does not have a valid value.') unless ALLOW_LANGUAGE_CODE.include?(to_lang.to_s.downcase)
    end

    def self.single_word?(str)
      !!(str =~ /^\p{L}+$/)
    end

    def self.raise_error!(message)
      TranslateLib::Exception.raise_error!(message)
    end
  end
end
