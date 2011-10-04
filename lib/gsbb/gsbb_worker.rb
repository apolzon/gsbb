require 'yaml'

class GsbbWorker
  def self.read_config
    if File.exists?("#{ENV['HOME']}/.gsbb")
      configuration = File.read("#{ENV['HOME']}/.gsbb", "r")
      parsed_config = YAML.parse(configuration)
      config_elements = parsed_config.children
      begin
        key_scalar, value_scalar = config_elements.slice!(0..1)
        class_variable_set("@@#{key_scalar.value}".to_sym, value_scalar.value)
      end while config_elements.count != 0
      @@cutoff = @@cutoff.to_i
      @@non_merged = eval(@@non_merged) if ["true", "false", ""].include?(@@non_merged)
    else
      @@cutoff = 21
      @@output = "some format string"
      @@non_merged = true
    end
  end

  def self.method_missing(method_name, *args)
    if method_name =~ /cutoff|output|non_merged/
      read_config
      class_variable_get "@@#{method_name}".to_sym
    else
      super method_name, *args
    end
  end

  def self.non_merged?
    !!self.non_merged
  end

  OUTPUT_VARIABLES = %w(%a %b %c)

  def self.output_variables
    OUTPUT_VARIABLES.join(", ")
  end

  def config
  end

  def show
    output = "Stale Branches:\n"
    stale_branches.each do |branch|
      output << "#{branch.name} - #{branch.commit.author}, #{(Date.today - branch.commit.authored_date.to_date).to_i} days old - #{branch.commit.authored_date.to_date}"
    end
    puts output
  end

  def prune
    puts "Pruning:"
    stale_branches.each do |branch|
      name = branch.name.split("/").last

      # Grit breaks here:
      # puts repo.git.native(:push, {:raise => true}, "origin :#{name}")

      puts `git push origin :#{name}`

      if repo.heads.map(&:name).include?(name)
        puts `git branch -D #{name}`
      end
    end
  end

  def email
    stale_branches.each do |branch|
      puts branch.commit.to_hash['committer']['email'] # win!
    end
  end

  def stale_branches
    @stale_branches ||= branches.select do |branch|
      commit = branch.commit
      commit.authored_date.to_date < (Date.today + 21)
    end
  end

  def branches
    @branches ||= repo.remotes.reject { |r| r.name =~ /hackfest|HEAD|master|production|staging|performance/ }
    @branches
  end

  def repo
    @repo ||= ::Grit::Repo.new('./')
  end

  def fully_merged_branches
    repo.git.branch({}, "--merged").strip.gsub("* ", "").split("\n")
  end
end