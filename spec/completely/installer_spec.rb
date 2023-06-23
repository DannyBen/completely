describe Installer do
  subject { described_class.new program: program, script_path: script_path }

  let(:leeway) { RUBY_VERSION < "3.2.0" ? 0 : 3 }
  let(:program) { 'completely-test' }
  let(:script_path) { 'completions.bash' }
  let(:expected_command) do
    %W[sudo cp #{subject.script_path} #{subject.target_path}]
  end

  describe '#target_directories' do
    it 'returns an array of potential completion directories' do
      expect(subject.target_directories).to be_an Array
      expect(subject.target_directories.size).to eq 3
    end
  end

  describe '#command' do
    it 'returns a copy command as an array' do
      expect(subject.command)
        .to eq %w[sudo cp completions.bash /usr/share/bash-completion/completions/completely-test]
    end

    context 'when the user is root' do
      it 'returns the command without sudo' do
        allow(subject).to receive(:root_user?).and_return true

        expect(subject.command)
          .to eq %w[cp completions.bash /usr/share/bash-completion/completions/completely-test]
      end
    end
  end

  describe '#command_string' do
    it 'returns the command as a string' do
      expect(subject.command_string).to eq subject.command.join(' ')
    end
  end

  describe '#target_path' do
    it 'returns the first matching path' do
      expect(subject.target_path)
        .to eq '/usr/share/bash-completion/completions/completely-test'
    end
  end

  describe '#install' do
    let(:existing_file) { 'spec/fixtures/existing-file.txt' }
    let(:missing_file) { 'tmp/missing-file' }

    before do
      allow(subject).to receive(:script_path).and_return existing_file
      allow(subject).to receive(:target_path).and_return missing_file
    end

    context 'when the completions_path cannot be found' do
      it 'raises an error' do
        allow(subject).to receive(:completions_path).and_return nil

        expect { subject.install }.to raise_approval('installer/install-no-dir')
          .diff(leeway)
      end
    end

    context 'when the script cannot be found' do
      it 'raises an error' do
        allow(subject).to receive(:script_path).and_return missing_file

        expect { subject.install }.to raise_approval('installer/install-no-script')
          .diff(leeway)
      end
    end

    context 'when the target exists' do
      it 'raises an error' do
        allow(subject).to receive(:target_path).and_return existing_file

        expect { subject.install }.to raise_approval('installer/install-target-exists')
          .diff(leeway)
      end
    end

    context 'when the target exists but force=true' do
      it 'proceeds to install' do
        allow(subject).to receive(:target_path).and_return existing_file

        expect(subject).to receive(:system).with(*expected_command)

        subject.install force: true
      end
    end

    context 'when the target does not exist' do
      it 'proceeds to install' do
        allow(subject).to receive(:target_path).and_return missing_file

        expect(subject).to receive(:system).with(*expected_command)

        subject.install
      end
    end
  end
end
