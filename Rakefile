desc 'Create a file with the whole code from requires (except ruby2d)'
task :prebuild do
  File.open('main-build.rb', 'w') do |file|
    output = include_requires('main.rb')
    file << output
  end
end

desc 'Build game'
task build: :prebuild do
  exec 'ruby2d build --all main-build.rb'
end

task :play do
  exec './build/app'
end

def include_requires(file)
  output = ''

  File.foreach(file) do |line|
    if line =~ /require ('|")ruby2d('|")/ || !(line =~ /require/)
      output << line
    else
      require_file = line.scan(/"([^"]+)"/)
      require_file = line.scan(/'([^']+)'/) if require_file.empty?

      filename = require_file.first.first # + '.rb'
      output << include_requires(filename)
    end
  end

  return output
end
