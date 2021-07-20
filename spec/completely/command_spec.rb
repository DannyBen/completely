require 'spec_helper'

describe Command do
  subject { CLI.runner }

  context "without arguments" do
    it "shows long usage" do
      expect { subject.run %w[] }.to output_approval('cli/usage')
    end
  end

  context "with --help" do
    it "shows long usage" do
      expect { subject.run %w[--help] }.to output_approval('cli/help')
    end
  end

  describe "new" do
    before { system "rm -f completely.yaml" }
    after  { system "rm -f completely.yaml" }
    let(:sample) { File.read "lib/completely/sample.yaml" }

    it "creates a new sample file named completely.yaml" do
      expect { subject.run %w[new] }.to output_approval('cli/new')
      expect(File.read 'completely.yaml').to eq sample
    end

    context "with an argument" do
      before { reset_tmp_dir }

      it "creates a new sample file named completely.yaml" do
        expect { subject.run %w[new spec/tmp/in.yaml] }.to output_approval('cli/new-path')
        expect(File.read 'spec/tmp/in.yaml').to eq sample
      end
    end

    context "when the config file already exists" do
      before { system "cp lib/completely/sample.yaml completely.yaml" }
      after  { system "rm -f completely.yaml" }
      
      it "raises an error" do
        expect { subject.run %w[new] }.to raise_approval('cli/new-error')
      end
    end
  end

  describe "preview" do
    before { system "cp lib/completely/sample.yaml completely.yaml" }
    after  { system "rm -f completely.yaml" }

    it "outputs the generated script to STDOUT" do
      expect { subject.run %w[preview] }.to output_approval('cli/generated-script')
    end

    context "with a path argument" do
      it "outputs the generated script to STDOUT" do
        expect { subject.run %w[preview completely.yaml] }.to output_approval('cli/generated-script')
      end
    end
  end

  describe "generate" do
    before { system "cp lib/completely/sample.yaml completely.yaml" }
    after  { system "rm -f completely.yaml" }

    it "generates the bash script to completely.bash" do
      expect { subject.run %w[generate] }.to output_approval('cli/generate')
      expect(File.read "completely.bash").to match_approval('cli/generated-script')
    end

    context "with a config path argument" do
      it "generates the bash script to completely.bash" do
        expect { subject.run %w[generate completely.yaml] }.to output_approval('cli/generate')
        expect(File.read "completely.bash").to match_approval('cli/generated-script')
      end
    end

    context "with a config path and output path arguments" do
      before { reset_tmp_dir }

      it "generates the bash script to the specified path" do
        expect { subject.run %w[generate completely.yaml spec/tmp/out.bash] }.to output_approval('cli/generate-path')
        expect(File.read "spec/tmp/out.bash").to match_approval('cli/generated-script')
      end
    end
  end
end
