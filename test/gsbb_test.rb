require 'minitest/spec'
require 'minitest/autorun'
require 'mocha'
require 'pry'

require File.expand_path(File.join(File.dirname(__FILE__), 'support', 'fake_grit'))

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'gsbb'))
ENV['test'] = 'true'

describe Gsbb do
  describe "#config" do
    it "allows setting the cut-off date"
    it "allows setting the branch exclusion rule"
    it "allows configuring the output style"
    it "allows excluding non-merged branches by default"
  end
  describe "#show" do
    it "includes author and branch name in output" do
      commit = FakeGrit::Commit.new
      commit.authored_date = Date.today - 22
      commit.author = "Bobby Bobberson"

      branch = FakeGrit::Branch.new
      branch.name = "branchname"
      branch.commit = commit

      repo = FakeGrit::Repo.new
      repo.remotes = [branch]

      Grit::Repo.expects(:new).returns(repo)

      output = Gsbb.new.show

      output.must_match /Bobby Bobberson/
      output.must_match /branchname/
    end
    it "includes merge-status in output"
    it "respects pre-configured cut-off date"
    it "respects pre-configured branch exclusion rule"
    it "respects pre-configured output style"
    it "respects pre-configured non-merge branch behavior"
    it "accepts a flag to exclude non-merged branches"
  end
end