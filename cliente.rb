#Por: Janilson Varela
#Data: 12/07/2015
#Cliente para solicitacao de serviço de registro de dominio
require 'socket'
hostname = 'localhost'
port = 2100
socket = TCPSocket.new(hostname, port)
socket.puts(gets.chomp)
puts socket.gets