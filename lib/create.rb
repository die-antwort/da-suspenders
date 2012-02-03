# Methods needed to create a project.

require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + "/errors")

module DaSuspenders
  class Create
    attr_accessor :project_path, :with_mongoid, :repo

    def self.run!(project_path, with_mongoid, repo)
      creator = self.new(project_path, with_mongoid == "--with-mongoid", repo)
      creator.create_project!
    end

    def initialize(project_path, with_mongoid, repo)
      self.project_path = project_path
      self.with_mongoid = with_mongoid
      self.repo = repo
      validate_project_path
      validate_project_name
      check_for_mongod_process if with_mongoid
    end

    def create_project!
      command = <<-COMMAND
        rails new #{project_path} \
          --template="#{template}" \
          --database=mysql \
          --skip-test-unit \
          #{'--skip-active-record' if with_mongoid}
      COMMAND
      ENV["REPO"] = repo if repo
      ENV["WITH_MONGOID"] = "1" if with_mongoid
      exec(command)
    end

    private

    def validate_project_name
      project_name = File.basename(project_path)
      unless project_name =~ /^[a-z0-9_]+$/
        raise InvalidInput.new("Project name must only contain [a-z0-9_]")
      end
    end

    def validate_project_path
      base_directory = Dir.pwd
      full_path = File.join(base_directory, project_path)

      # This is for the common case for the user's convenience; the race
      # condition can still occur.
      if File.exists?(full_path)
        raise InvalidInput.new("Project directory (#{project_path}) already exists")
      end
    end

    def check_for_mongod_process
      unless system("ps aux | grep mongod | grep -vq grep")
        raise InvalidInput.new("mongod process not found (mongod must be running when using --with-mongoid)")
      end
    end
    
    def template
      File.expand_path(File.dirname(__FILE__) + "/../template/da-suspenders.rb")
    end
  end
end
