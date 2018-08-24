Aruba.configure do |config|
    puts %(The default value is "#{config.console_history_file}")
    puts %(The defautl value is "#{config.exit_timeout}")
    puts %(The default value is "%w(#{config.fixtures_directories.join(" ")})")
    puts %(The default value is "#{config.log_level}")
    puts %(The default value is "#{config.physical_block_size}")
    puts %(The default value is "#{config.startup_wait_time}")
end

Aruba.configure do |config|
    config.log_level = :debug
    #config.exit_timeout = 1
end