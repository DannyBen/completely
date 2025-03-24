describe Config do
  subject { described_class.load path }

  let(:path) { "spec/fixtures/#{file}.yaml" }
  let(:file) { 'nested' }

  describe '#flat_config' do
    it 'returns a flat pattern => completions hash' do
      expect(subject.flat_config.to_yaml).to match_approval('config/flat_config')
    end
  end

  context 'when complete_options is defined' do
    let(:file) { 'complete_options' }

    describe 'config' do
      it 'ignores the completely_config YAML key' do
        expect(subject.config.keys).to eq ["mygit"]
      end
    end

    describe 'options' do
      it 'returns complete_options from the YAML file' do
        expect(subject.options[:complete_options]).to eq '-o nosort'
      end
    end
  end
end
