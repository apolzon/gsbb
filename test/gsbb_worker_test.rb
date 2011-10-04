require 'minitest/spec'
require 'minitest/autorun'
require 'pry'
require 'turn'

require File.expand_path(File.join(File.dirname(__FILE__), 'support', 'fake_grit'))
require File.expand_path(File.join(File.dirname(__FILE__), 'support', 'capture_stdout'))

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'gsbb'))
require 'mocha'

describe GsbbWorker do
  after do
    # Clear class variables -- one of the many reasons NOT to use these evil things...
    GsbbWorker.class_variables.each do |class_var|
      GsbbWorker.class_variable_set(class_var, nil)
    end
    GsbbWorker.class_variable_set(:@@cutoff, nil)
  end

  describe ".read_config" do
    describe "config file exists" do
      before do
        File.expects(:exists?).with("#{ENV['HOME']}/.gsbb").returns(true)
        File.expects(:read).with("#{ENV['HOME']}/.gsbb", "r").returns(YAML.dump 'cutoff' => 15, 'output' => "some string", 'non_merged' => false)
      end
      it "reads config file from users home directory" do
        GsbbWorker.read_config
      end
      it "stores config values" do
        GsbbWorker.read_config
        GsbbWorker.class_variable_get(:@@cutoff).must_equal 15
        GsbbWorker.class_variable_get(:@@output).must_equal "some string"
        GsbbWorker.class_variable_get(:@@non_merged).must_equal false
      end
    end
    describe "no config file exists" do
      it "uses defaults" do
        GsbbWorker.read_config
        GsbbWorker.cutoff.must_equal 21
        GsbbWorker.output.wont_be_nil
        GsbbWorker.non_merged.must_equal true
        GsbbWorker.non_merged?.must_equal true
      end
    end
  end

  describe ".cutoff" do
    it "reads from configuration file" do
      GsbbWorker.expects(:read_config)
      GsbbWorker.cutoff
    end
  end
  describe ".output" do
    it "reads from configuration file" do
      GsbbWorker.expects(:read_config)
      GsbbWorker.output
    end
  end
  describe ".non_merged?" do
    it "reads from configuration file" do
      GsbbWorker.expects(:read_config)
      GsbbWorker.non_merged?
    end
  end
  describe ".non_merged" do
    it "reads from configuration file" do
      GsbbWorker.expects(:read_config)
      GsbbWorker.non_merged
    end
  end
  describe ".fake_method" do
    it "raises no method error" do
      lambda { GsbbWorker.fake_method }.must_raise(NoMethodError)
    end
  end

  #describe ".output_variables"
  #
  #describe "#config"
  #describe "#show"
  #describe "#prune"
  #describe "#email"
  #
  #describe "#stale_branches"
  #describe "#branches"
  #describe "#repo"
  #describe "#full_merged_branches"
end