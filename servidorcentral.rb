require 'socket'


server = UDPSocket.new
server.bind("",2010)

puts "Servidor Iniciado"
puts "Lista de Servidor(es) registrado(s)"
f = File.new("ListaServers.txt")
f.each {|line| print line}
f.close
loop{
	data, sender = server.recvfrom(1024)
	arr = data.split

	if arr[0] == 'REG'
		puts "Solicitacao de REG"
		puts "Dominio para registro: "+arr[1]
		puts "IP do Dominio: "+arr[2]
	end
}
