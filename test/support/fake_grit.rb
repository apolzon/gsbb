module FakeGrit
  class Commit
    attr_accessor :author, :authored_date
  end

  class Branch
    attr_accessor :commit, :name
  end

  class Repo
    attr_accessor :remotes
  end
end