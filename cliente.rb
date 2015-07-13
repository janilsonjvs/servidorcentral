=begin
require 'socket'
socket = UDPSocket.new
socket.connect('localhost',2100)
msg = gets
socket.puts msg
puts socket.gets
=end
require 'socket'
  def test_REG_REGOK

    msg_out = "REG bentofernandes 10.6.6.50"

    msg_esperada = "REGOK"

    sock = UDPSocket.new

    sock.connect("localhost", "2100")

    sock.print(msg_out)

    msg_in = sock.recvfrom(20)[0]

    assert_equal(msg_esperada, msg_in)
    puts socket.gets
    sock.close
  end

 puts test_REG_REGOK