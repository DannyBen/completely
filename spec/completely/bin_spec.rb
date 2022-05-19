require 'spec_helper'

describe 'bin/completely' do
  subject { CLI.runner }

  it "shows list of commands" do
    expect{ subject.run }.to output_approval('cli/commands')
  end

  context "on error" do
    it "displays it nicely" do
      expect(`bin/completely preview notfound.yaml 2>&1`).to match_approval('cli/error')
    end
  end
end
