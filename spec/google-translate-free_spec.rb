require 'google-translate-free'

RSpec.describe Translate do
  context 'Translation' do
    it 'translates text with auto-detected language' do
      expect(Translate.translate('summer', :vi)).to eq('mùa hè')
    end

    it 'translates text with specified source language' do
      expect(Translate.translate('summer', :vi, :en)).to eq('mùa hè')
    end

    it 'raises an exception for string over 5000 characters' do
      param = 'a' * 5001
      expect { Translate.translate(param, :vi) }.to raise_error(TranslateLib::Exception, 'Translate strings shorter than or equal to 5000 characters.')
    end

    it 'raises an exception for invalid target language code' do
      expect { Translate.translate('summer', :viii) }.to raise_error(TranslateLib::Exception, 'to_lang does not have a valid value.')
    end

    it 'raises an exception for invalid source language code' do
      expect { Translate.translate('summer', :vi, :ennn) }.to raise_error(TranslateLib::Exception, 'from_lang does not have a valid value.')
    end
  end

  context 'Alternate Translations' do
    it 'returns alternate translations with auto-detected language' do
      result = Translate.alternate_translations('how about you?', :vi)
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end

    it 'returns alternate translations with specified source language' do
      result = Translate.alternate_translations('how about you?', :vi, :en)
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end

    it 'raises an exception for string over 5000 characters' do
      param = 'a' * 5001
      expect { Translate.alternate_translations(param, :vi) }.to raise_error(TranslateLib::Exception, 'Translate strings shorter than or equal to 5000 characters.')
    end

    it 'raises an exception for invalid target language code' do
      expect { Translate.alternate_translations('summer', :viii) }.to raise_error(TranslateLib::Exception, 'to_lang does not have a valid value.')
    end

    it 'raises an exception for invalid source language code' do
      expect { Translate.alternate_translations('summer', :vi, :ennn) }.to raise_error(TranslateLib::Exception, 'from_lang does not have a valid value.')
    end
  end

  context 'Definitions' do
    it 'returns definitions' do
      result = Translate.definitions('summer')
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end

    it 'raises an exception for multi-word keyword' do
      param = 'hello datpmt'
      expect { Translate.definitions(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end

  context 'Examples' do
    it 'returns examples' do
      result = Translate.examples('summer')
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end

    it 'raises an exception for multi-word keyword' do
      param = 'hello datpmt'
      expect { Translate.examples(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end

  context 'Transliteration' do
    it 'returns transliteration' do
      result = Translate.transliteration('summer')
      expect(result).to be_a(String)
      expect(result).not_to be_empty
    end

    it 'raises an exception for multi-word keyword' do
      param = 'hello datpmt'
      expect { Translate.transliteration(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end

  context 'Spelling Suggestions' do
    it 'returns English spelling suggestions' do
      expect(Translate.suggest('summmer')).to eq('summer')
      expect(Translate.suggest('how aboutt you')).to eq('how about you')
    end

    it 'returns Vietnamese spelling suggestions' do
      expect(Translate.suggest('tôii yêu bạn')).to eq('tôi yêu bạn')
      expect(Translate.suggest('bạn biếtt không?')).to eq('bạn biết không?')
    end

    it 'raises an exception for string over 5000 characters' do
      param = 'a' * 5001
      expect { Translate.suggest(param) }.to raise_error(TranslateLib::Exception, 'Translate strings shorter than or equal to 5000 characters.')
    end
  end

  context 'Language Detection' do
    it 'detects English language' do
      result = Translate.detection('summer')
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
      expect(result.size).to eq(2)
      expect(result[0]).to eq 'en'
      expect(result[1]).to be_a(Float).or be_a(Integer)
    end

    it 'detects Vietnamese language' do
      result = Translate.detection('bà tôi')
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
      expect(result.size).to eq(2)
      expect(result[0]).to eq 'vi'
      expect(result[1]).to be_a(Float).or be_a(Integer)
    end

    it 'raises an exception for string over 5000 characters' do
      param = 'a' * 5001
      expect { Translate.detection(param) }.to raise_error(TranslateLib::Exception, 'Translate strings shorter than or equal to 5000 characters.')
    end
  end

  context 'Keyword Suggestions' do
    it 'returns keyword suggestions' do
      expect(Translate.see_more('summers')).to eq('summer')
      expect(Translate.see_more('kids')).to eq('kid')
    end

    it 'raises an exception for multi-word keyword' do
      param = 'hello datpmt'
      expect { Translate.see_more(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end
end
