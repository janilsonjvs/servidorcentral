require 'socket'


server = UDPSocket.new
server.bind("",2010)

puts "Servidor Iniciado"
puts "Lista de Servidor(es) registrado(s)"

f = File.new("ListaServers.txt","w+")
bip = false

f.each {|line| print line}
f.close
loop{
	data, sender = server.recvfrom(1024)
	c_ip = sender[3] # ip do cliente
	c_porta = sender[1] # porta do cliente
	puts "IP do cliente Conectado: #{c_ip}"
	f2 = File.new("ListaServers.txt")
	f2.each {|li| 
		puts c_ip
		if (li == c_ip) then
			bip = true
		end
	}
	f2.close

	if (bip == false) then
		f3 = File.new("ListaServers.txt","a+")
		f3.puts c_ip
		f3.close	
		puts "Novo IP registrado: #{c_ip}"
	end
}



