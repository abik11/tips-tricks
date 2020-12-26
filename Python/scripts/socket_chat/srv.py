import socket
import sockchat as sock

srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host = socket.gethostname()
port = 10200

srv.bind((host, port))

srv.listen(5)

print("Waiting for incoming connections...")
while True:
    client,addr = srv.accept() #establish connection
    print("Got a connection from %s" % str(addr))

    while True:
        if not sock.send_msg(client):
            break

        if sock.recv_msg(client, info_msg = 'Client closed connection.') == '':
            break
