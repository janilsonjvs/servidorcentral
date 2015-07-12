require 'socket'
socket = UDPSocket.new
socket.connect('localhost',2010)
loop{
msg = gets
socket.puts msg
puts socket.gets
}
socket.close