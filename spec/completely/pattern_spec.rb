require 'spec_helper'

describe Pattern do
  subject { described_class.new text, completions, function_name }
  let(:text) { "git commit" }
  let(:completions) { %w[--message --help <file> <user>] }
  let(:function_name) { "_filter" }

  describe '#length' do
    it "returns the string length of the pattern text" do
      expect(subject.length).to eq 10
    end
  end

  describe '#empty?' do
    it "returns false" do
      expect(subject).not_to be_empty
    end

    context "when there are no completions" do
      let(:completions) { nil }

      it "returns true" do
        expect(subject).to be_empty
      end
    end
  end

  describe '#words' do
    it "returns an array for compgen -W" do
      expect(subject.words).to eq %w[--message --help]
    end
  end

  describe '#actions' do
    it "returns an array for compgen -A" do
      expect(subject.actions).to eq ["-A file", "-A user"]
    end
  end

  describe '#prefix' do
    it "returns the first word from text" do
      expect(subject.prefix).to eq "git"
    end
  end

  describe '#case_string' do
    it "returns the quoted pattern (excluding command name) with a wildcard suffix" do
      expect(subject.case_string).to eq "'commit'*"
    end

    context "when the pattern (excluding command name) is empty" do
      let(:text) { "git" }

      it "returns '*'" do
        expect(subject.case_string).to eq "*"
      end
    end

    context "when the pattern includes a wildcard" do
      let(:text) { "git checkout*--branch" }

      it "returns the quoted pattern (excluding command name) with an unquoted wildcard and without a wildcard suffix" do
        expect(subject.case_string).to eq "'checkout'*'--branch'"
      end
    end
  end

  describe '#text_without_prefix' do
    it "returns all but the first word from text" do
      expect(subject.text_without_prefix).to eq "commit"
    end
  end

  describe '#compgen' do
    it "returns a line of compgen arguments" do
      expect(subject.compgen).to eq %q[-A file -A user -W "$(_filter "--message --help")"]
    end

    context "when there are no words for -W" do
      let(:completions) { %w[<file> <user>] }

      it "omits the -W argument" do
        expect(subject.compgen).to eq %q[-A file -A user]
      end
    end

    context "when there are no actions for -A" do
      let(:completions) { %w[--message --help] }

      it "omits the -A arguments" do
        expect(subject.compgen).to eq %q[-W "$(_filter "--message --help")"]
      end
    end

    context "when there are no completions" do
      let(:completions) { nil }

      it "returns nil" do
        expect(subject.compgen).to be_nil
      end
    end
  end
end
