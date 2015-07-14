#Por: Janilson Varela
#Data: 12/07/2015
#Servidor para registro de dominio


require 'socket'
require 'rdbi-driver-sqlite3'

server = UDPSocket.new
server.bind("", 2100)
puts "Servidor Central iniciado"
dbh = RDBI.connect( :SQLite3, :database => "dbregistro.db" )
aspas = '"'
msgREGOK = "REGOK"
msgREGFALHA = "REGFALHA"
msgIPOK = "IPOK"
msgIPFALHA = "IPFALHA"
msgFALHA = "FALHA"
res = nil
	#Lista os Dominios e IP registrados
	rs = dbh.execute("select IP from dns")
	rs.fetch(:all).each do |row|
		puts row[0]
	end

loop {
	dados, sender = server.recvfrom(1024)
	
	arr = dados.split
	c_ip = sender[3]
	c_port = sender[1]
	if (arr[0] == "IP" and arr.length == 2) then
		if (arr[1] != nil) then
			rs = dbh.execute("select ip from dns where dominio = #{aspas} #{arr[1]} #{aspas}")
			rs.fetch(:all).each do |row|
				res = row[0]
			end
			puts res
			if res != nil then
				server.send( msgIPOK + "#{res}", 0, c_ip, c_porta)
			elsif (res == nil) then
				server.send  msgIPFALHA, 0, c_ip, c_porta
			end

		end
	elsif (arr[0] == "REG" and arr.length == 3) then
		if (arr[1] != nil and arr[2] != nil) then
			begin
				dbh.execute("insert into dns (dominio, ip) values ( #{aspas}#{arr[1]}#{aspas}, #{aspas}#{arr[2]}#{aspas})")
				server.send msgREGOK, 0 , c_ip, c_porta
			rescue
				server.send msgREGFALHA, 0, c_ip, c_porta
			end

		end
	else
		server.send msgFALHA, 0, c_ip, c_porta	
	end
}
server.close
