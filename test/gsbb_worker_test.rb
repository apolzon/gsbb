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
        File.stubs(:exists?).with("#{ENV['HOME']}/.gsbb").returns(false)
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

  describe ".current_config" do
    it "returns defaults when no config exists" do
      GsbbWorker.expects(:read_config)
      GsbbWorker.class_exec do
        @@config_read = false
        @@cutoff = 15
        @@output = "some format string"
        @@non_merged = true
      end
      GsbbWorker.current_config.must_equal({:cutoff => 15, :output => "some format string", :non_merged => true})
    end
    it "doesn't read from file system unnecessarily" do
      GsbbWorker.class_exec do
        @@config_read = true
        @@cutoff = 1
        @@output = "testme"
        @@non_merged = false
      end
      GsbbWorker.expects(:read_config).never
      GsbbWorker.current_config.must_equal({:cutoff => 1, :output => "testme", :non_merged => false})
    end
  end

  describe "#config" do
    describe "hash of optional parameters" do
      describe "cutoff" do
        describe "when present" do
          before do
            GsbbWorker.any_instance.expects(:write_config).with({:cutoff => 15, :output => "some format string", :non_merged => true})
            @output = capture_stdout { GsbbWorker.new.config(:cutoff => 15) }
          end
          it "outputs updated value" do
            @output.must_match /Successfully updated cutoff date to 15 days/
          end
        end
        describe "when not present" do
          it "does nothing" do
            GsbbWorker.any_instance.expects(:write_config).with({:cutoff => 21, :output => "some format string", :non_merged => true})
            output = capture_stdout { GsbbWorker.new.config({}) }
            output.wont_match /Successfully updated cutoff date/
          end
        end
      end
    end
  end
  #describe "#show"
  #describe "#prune"
  #describe "#email"
  #
  #describe "#stale_branches"
  #describe "#branches"
  #describe "#repo"
  #describe "#full_merged_branches"
end