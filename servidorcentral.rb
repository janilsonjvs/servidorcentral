#Por: Janilson Varela
#Data: 12/07/2015
#Servidor para registro de dominio

require 'socket'
server = TCPServer.new(2100)

puts "Servidor de Registro iniciado."
puts "Lista de Servidor(es) registrado(s)"
f = File.new("ListaServers.txt")
f.each {|line| print line}
f.close
msgREGOK = "REGOK"
msgREGFALHA = "REGFALHA"
msgIPFALHA = "IPFALHA"
msgFALHA = "FALHA"

loop{
	clientSocket =  server.accept
	data = clientSocket.gets
	arr = data.split
	rge = false

	if arr[0] == 'REG' then
		puts "Solicitacao de REG"

		f1 = File.new("ListaServers.txt")
		f1.each {|li|
			dom = li.split

			if dom[1] == arr[1]
				puts "Dominio ja registrado!"	
				clientSocket.puts(msgREGFALHA) 
				rge = true
				break
			end
		}
		f1.close

		if rge == false
			f1 = File.new("ListaServers.txt","a+")
			f1.puts data
			f1.close
			puts "Dominio para registro: "+arr[1]
			puts "IP do Dominio: "+arr[2]	
			clientSocket.puts(msgREGOK) 
		end


	elsif arr[0] == 'IP' then
		puts "Solicitacao de IP"

		f1 = File.new("ListaServers.txt")
		f1.each {|li|
			dom = li.split

			if dom[1] == arr[1]
				rge = true
				puts dom[2]
				clientSocket.puts(dom[2].to_s) 
				break
			end
		}
		f1.close		

		if rge == false
			clientSocket.puts(msgIPFALHA) 
		end
	else
		clientSocket.puts(msgFALHA) 
		
	end
}
