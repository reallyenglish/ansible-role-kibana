require 'tempfile'
require 'pathname'

role_dir = Pathname.new(__FILE__).dirname
role_name = Pathname.new(role_dir).basename

task default: %w[ integration:standalone:test ]

namespace :integration do

  base_dir = 'test/integration'

  namespace :standalone do |namespace|
    scope = namespace.scope.path.split(':').last # String, not sym
    desc "test #{scope}"
    task :test => [ :cleanup, :prepare, :do_test, :ensure_cleanup ]

    desc 'Do the test'
    task :do_test do
      Dir.chdir("#{base_dir}/#{scope}") do
        sh 'vagrant up'
        sh 'bundle exec rspec'
      end
    end

    desc 'prepare the test environment'
    task :prepare do
      ignore_files = %w[ vendor .kitchen .git test spec ].map { |f| "#{role_name}/#{f}" }
      tmpfile = Tempfile.new('.tarignore')
      tmpfile.write ignore_files.join("\n")
      tmpfile.close
      sh "tar -c -X #{tmpfile.path} -C ../ -f - #{role_name} | tar -x -C #{base_dir}/#{scope}/roles -f -"
    end

    desc 'cleanup'
    task :cleanup => [ :cleanup_vagrant, :cleanup_role ] do
    end
    
    desc 'destroy vagrant nodes'
    task :cleanup_vagrant do
      Dir.chdir("#{base_dir}/#{scope}") do
        sh 'vagrant destroy -f'
      end
    end

    desc "rm #{base_dir}/#{scope}/roles/*"
    task :cleanup_role do
      sh "rm -rf #{base_dir}/sentinel/roles/*"
    end

    desc 'do cleanup task even if it has been executed'
    task :ensure_cleanup do
      Rake::Task["integration:#{scope}:cleanup"].all_prerequisite_tasks.each do |task|
        task.reenable
      end
      Rake::Task["integration:#{scope}:cleanup"].reenable
      Rake::Task["integration:#{scope}:cleanup"].invoke
    end
  end

end
