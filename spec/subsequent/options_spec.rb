RSpec.describe Subsequent::Options do
  describe '.register' do
    it 'returns @registered_options[symbol] = option' do
      skip 'Buttress cannot yet evaluate: @registered_options ||= {}'

      Subsequent::Options.register('blah1', 'blah2')
    end
  end

  describe '.fetch' do
    it 'returns @registered_options.fetch(symbol)' do
      skip 'Buttress cannot yet evaluate: @registered_options'

      Subsequent::Options.fetch('blah1')
    end
  end
end
