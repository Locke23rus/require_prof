def stamp(name)
  start_time = Time.now
  begin
    require name
  rescue LoadError
  end
ensure
  time = (Time.now - start_time) * 1000
  puts "#{time.round(2)}ms - #{name}"
end

stamp 'time'
stamp 'not_exist_file1'
stamp 'not_exist_file2'
