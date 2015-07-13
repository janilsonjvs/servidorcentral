require 'socket'


server = UDPSocket.new
server.bind("",2100)

puts "Servidor Iniciado"
puts "Lista de Servidor(es) registrado(s)"
f = File.new("ListaServers.txt")
f.each {|line| print line}
f.close
msgREGOK = "REGOK"


loop{
	data, sender = server.recvfrom(1024)
	c_ip = sender[3]
	c_porta = sender[1]
	arr = data.split
	rge = false

	if arr[0] == 'REG'
		puts "Solicitacao de REG"

		f1 = File.new("ListaServers.txt")
		f1.each {|li|
			dom = li.split

			if dom[1] == arr[1]
				puts "Dominio ja registrado!"	
				rge = true
				break
			end
		}
		f1.close

		if rge == false
			f2 = File.new("ListaServers.txt","a+")
			f2.puts data
			f2.close
			puts "Dominio para registro: "+arr[1]
			puts "IP do Dominio: "+arr[2]	
			puts "IP Cliente: #{c_ip}"		
			puts "Porta Cliente: #{c_porta}"		
			#server.send(msgREGOK,c_ip, c_porta)
		end
	end
}
