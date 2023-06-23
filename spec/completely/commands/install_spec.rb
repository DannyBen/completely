describe Commands::Install do
  subject { described_class.new }

  let :mock_installer do
    instance_double Installer,
      install:        true,
      target_path:    'some-target-path',
      command_string: 'sudo cp source target'
  end

  context 'with --help' do
    it 'shows long usage' do
      expect { subject.execute %w[install --help] }
        .to output_approval('cli/install/help').diff(10)
    end
  end

  context 'without arguments' do
    it 'shows short usage' do
      expect { subject.execute %w[install] }
        .to output_approval('cli/install/no-args')
    end
  end

  context 'with PROGRAM' do
    it 'invokes the Installer' do
      allow(subject).to receive(:installer).and_return(mock_installer)

      expect(mock_installer).to receive(:install)

      expect { subject.execute %w[install completely-test] }
        .to output_approval('cli/install/install')
    end
  end

  context 'with PROGRAM --dry' do
    it 'shows the command and does not install anything' do
      expect(mock_installer).not_to receive(:install)

      expect { subject.execute %w[install completely-test --dry] }
        .to output_approval('cli/install/dry')
    end
  end

  context 'when the installer fails' do
    it 'raises an error' do
      allow(subject).to receive(:installer).and_return(mock_installer)

      expect(mock_installer).to receive(:install).and_return false

      expect { subject.execute %w[install completely-test] }
        .to raise_approval('cli/install/install-error')
    end
  end
end
