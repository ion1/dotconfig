begin
  require 'rubygems'
rescue LoadError
  # ignore
end

begin
  require 'wirble'

  # Start wirble (with color).
  Wirble.init
  Wirble.colorize
rescue LoadError
  warn "Failed to load wirble"
end

