require 'socket'
socket = UDPSocket.new
socket.connect('localhost',2100)
msg = gets
socket.puts msg
puts socket.gets
#socket.close