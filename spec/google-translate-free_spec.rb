require 'google-translate-free'

RSpec.describe Translate do
  context 'Translate' do
    it 'Translate auto detect language' do
      expect(Translate.translate('summer', :vi)).to eq('mùa hè')
    end

    it 'Translate with source language' do
      expect(Translate.translate('summer', :vi, :en)).to eq('mùa hè')
    end

    it 'Raises an exception for param string over 5000 characters' do
      param = 'a' * 5001
      expect { Translate.translate(param, :vi) }.to raise_error(TranslateLib::Exception, 'Translate strings shorter than or equal to 5000 characters.')
    end

    it 'Raises an exception for invalid language code' do
      expect { Translate.translate('summer', :viii) }.to raise_error(TranslateLib::Exception, 'to_lang does not have a valid value.')
    end

    it 'Raises an exception for invalid language code' do
      expect { Translate.translate('summer', :vi, :ennn) }.to raise_error(TranslateLib::Exception, 'from_lang does not have a valid value.')
    end
  end

  context 'For alternate Translations' do
    it 'Translate auto detect language' do
      result = Translate.alternate_translations('how about you?', :vi)
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end

    it 'Translate with source language' do
      result = Translate.alternate_translations('how about you?', :vi, :en)
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end

    it 'Raises an exception for param string over 5000 characters' do
      param = 'a' * 5001
      expect { Translate.translate(param, :vi) }.to raise_error(TranslateLib::Exception, 'Translate strings shorter than or equal to 5000 characters.')
    end

    it 'Raises an exception for invalid language code' do
      expect { Translate.translate('summer', :viii) }.to raise_error(TranslateLib::Exception, 'to_lang does not have a valid value.')
    end

    it 'Raises an exception for invalid language code' do
      expect { Translate.translate('summer', :vi, :ennn) }.to raise_error(TranslateLib::Exception, 'from_lang does not have a valid value.')
    end
  end

  context 'Definitions' do
    it 'For definitions' do
      result = Translate.definitions('summer')
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end

    it 'Raises an exception for param keyword if not is a single word' do
      param = 'hello datpmt'
      expect { Translate.definitions(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end

  context 'Examples' do
    it 'For examples' do
      result = Translate.examples('summer')
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
    end

    it 'Raises an exception for param keyword if not is a single word' do
      param = 'hello datpmt'
      expect { Translate.examples(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end

  context 'Transliteration' do
    it 'For transliteration' do
      result = Translate.transliteration('summer')
      expect(result).to be_a(String)
      expect(result).not_to be_empty
    end

    it 'Raises an exception for param keyword if not is a single word' do
      param = 'hello datpmt'
      expect { Translate.transliteration(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end

  context 'Transliteration' do
    it 'For transliteration' do
      result = Translate.transliteration('summer')
      expect(result).to be_a(String)
      expect(result).not_to be_empty
    end

    it 'Raises an exception for param keyword if not is a single word' do
      param = 'hello datpmt'
      expect { Translate.transliteration(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end

  context 'Spelling suggestions' do
    it 'For spelling suggestions' do
      expect(Translate.suggest('summmer')).to eq('summer')
      expect(Translate.suggest('how aboutt you')).to eq('how about you')
    end

    it 'Raises an exception for param string over 5000 characters' do
      param = 'a' * 5001
      expect { Translate.suggest(param) }.to raise_error(TranslateLib::Exception, 'Translate strings shorter than or equal to 5000 characters.')
    end
  end

  context 'Language detection' do
    it 'For language detection' do
      result = Translate.detection('summer')
      expect(result).to be_a(Array)
      expect(result).not_to be_empty
      expect(result.size).to eq(2)
      expect(result[0]).to be_a(String)
      expect(result[1]).to be_a(Float)
    end

    it 'Raises an exception for param string over 5000 characters' do
      param = 'a' * 5001
      expect { Translate.detection(param) }.to raise_error(TranslateLib::Exception, 'Translate strings shorter than or equal to 5000 characters.')
    end
  end

  context 'Keyword suggestions' do
    it 'For keyword suggestions' do
      expect(Translate.see_more('summers')).to eq('summer')
      expect(Translate.see_more('kids')).to eq('kid')
    end

    it 'Raises an exception for param keyword if not is a single word' do
      param = 'hello datpmt'
      expect { Translate.see_more(param) }.to raise_error(TranslateLib::Exception, 'keyword does not have a valid value.')
    end
  end
end
