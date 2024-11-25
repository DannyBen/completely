describe Config do
  subject { described_class.load path }

  let(:path) { "spec/fixtures/#{file}.yaml" }
  let(:file) { 'nested' }

  describe '#flat_config' do
    it 'returns a flat pattern => completions hash' do
      expect(subject.flat_config.to_yaml).to match_approval('config/flat_config')
    end
  end
end
