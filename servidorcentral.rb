require 'socket'


server = TCPServer.new(2010)
puts "Servidor Iniciado"
puts "Lista de Servidor(es) registrado(s)"

f = File.new("ListaServers.txt")

f.each {|line| print line}
f.close
client = server.accept
loop{
	data, sender = server.recvfrom(1024)
	c_ip = sender[3] # ip do cliente
	c_porta = sender[1] # porta do cliente
	puts "Dados do cliente #{c_ip}"

}


