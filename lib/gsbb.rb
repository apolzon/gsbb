require 'grit'
require 'thor'
require File.expand_path(File.join(File.dirname(__FILE__), 'gsbb', 'gsbb_worker'))

class Gsbb < Thor
  desc "config", "Configure overrides to default behavior"
  method_options :cutoff => :numeric, :output => :string, :non_merged => :boolean
  def config
    p options
    # options.force? # options['alias'] # options[:alias]
    test = "hi"
    if options.keys == []
      puts <<-EOS
        Configure [--cutoff=number_of_days --output="formatted string" --no-non-merged]

        Current Settings:

        Cutoff: #{GsbbWorker.cutoff}
          Update with: gsbb config --cutoff=15

        Output: #{GsbbWorker.output}
          Update with: gsbb config --ouput=""
          Available variables:
          #{GsbbWorker.output_variables}

        Include non-merged branches: #{GsbbWorker.non_merged?}
          Update with: gsbb config --[no-]non-merged
                       gsbb config --non-merged={false,true}

      EOS
    else
      worker = GsbbWorker.new.config
    end
  end

  desc "show", "List stale branches"
  def show
    worker = GsbbWorker.new.show
  end

  desc "prune", "Remove all stale branches from remote"
  def prune
    worker = GsbbWorker.new.prune
  end

  desc "email", "Email each stale branch author requesting branch removal"
  def email
    worker = GsbbWorker.new.email
  end
end