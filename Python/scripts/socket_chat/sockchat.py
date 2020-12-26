def send_msg(socket, msg = '', enconding = 'ascii', quit_cmd = 'cmd_quit', prompt = '> '):
    if msg == '':
        msg = input(prompt)

    if msg == quit_cmd:
        socket.send(quit_cmd.encode(enconding))
        socket.close()
        return False

    socket.send(msg.encode(enconding))
    return True

def recv_msg(socket, bytesCount = 1024, enconding = 'ascii', quit_cmd = 'cmd_quit', prompt = '# ', info_msg = 'Connection closed.'):
    msg = socket.recv(bytesCount).decode()
        
    if msg == quit_cmd:
        print(info_msg)
        socket.close()
        return ''

    if msg != '':
        print(prompt + msg)

    return msg
