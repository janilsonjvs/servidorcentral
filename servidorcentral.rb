require 'socket'
server = TCPServer.new(2010)
puts "Servidor Iniciado"
puts "Lista de Servidor(es) registrado(s)"

f = File.new("ListaServers.txt","a+")

f.each {|line| print line}