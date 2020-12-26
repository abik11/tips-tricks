import socket
import sockchat as sock

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host = socket.gethostname()
port = 10200

s.connect((host, port))

print("Waiting for server response...")
while True:
    if sock.recv_msg(s, info_msg = 'Server closed connection.') == '':
        break

    if not sock.send_msg(s):
        break
