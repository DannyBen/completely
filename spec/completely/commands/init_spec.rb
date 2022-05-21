require 'spec_helper'

describe Commands::Init do
  subject { CLI.runner }
  before { system "rm -f completely.yaml" }
  after  { system "rm -f completely.yaml" }
  let(:sample) { File.read "lib/completely/templates/sample.yaml" }

  context "with --help" do
    it "shows long usage" do
      expect{ subject.run %w[init --help] }.to output_approval('cli/init/help')
    end
  end

  context "without arguments" do
    it "creates a new sample file named completely.yaml" do
      expect { subject.run %w[init] }.to output_approval('cli/init/no-args')
      expect(File.read 'completely.yaml').to eq sample
    end
  end

  context "with CONFIG_PATH" do
    before { reset_tmp_dir }

    it "creates a new sample file with the requested name" do
      expect { subject.run %w[init spec/tmp/in.yaml] }
        .to output_approval('cli/init/custom-path')
      expect(File.read 'spec/tmp/in.yaml').to eq sample
    end
  end

  context "with COMPLETELY_CONFIG_PATH env var" do
    before do
      reset_tmp_dir
      ENV['COMPLETELY_CONFIG_PATH'] = 'spec/tmp/hello.yml'
    end

    after { ENV['COMPLETELY_CONFIG_PATH'] = nil }

    it "creates a new sample file with the requested name" do
      expect { subject.run %w[init] }
        .to output_approval('cli/init/custom-path-env')
      expect(File.read 'spec/tmp/hello.yml').to eq sample
    end
  end

  context "when the config file already exists" do
    before { system "cp lib/completely/templates/sample.yaml completely.yaml" }
    after  { system "rm -f completely.yaml" }
    
    it "raises an error" do
      expect { subject.run %w[init] }.to raise_approval('cli/init/file-exists')
    end
  end

end
