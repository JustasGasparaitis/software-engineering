import socket
import sys
import threading


class ChatterboxConnection(object):
    def __init__(self, conn):
        self.conn = conn

    def __getattr__(self, name):
        return getattr(self.conn, name)

    def sendall(self, data):
        dataStr = data
        print("send: %r" % data)
        self.conn.sendall(dataStr.encode('utf-8'))

    def recvall(self, END='\r\n'):
        data = []
        while True:
            chunk = self.conn.recv(4096).decode('utf-8')
            if END in chunk:
                data.append(chunk[:chunk.index(END)])
                break
            data.append(chunk)
            if len(data) > 1:
                pair = data[-2] + data[-1]
                if END in pair:
                    data[-2] = pair[:pair.index(END)]
                    data.pop()
                    break
        print("recv: %r" % "".join(data))
        return "".join(data)


users = {
    "justas": "123",
    "mariu": "123",
    "juozas": "123",
}

messages = [
    "\r\nLabas labas labas ...",
    "\r\nbabas babas babas ...",
    "\r\nkrabas krabas krabas ...",
    "\r\nzazas zazas zazas ...",
    "\r\ntrakzas trakzas trakzas ...",
]

messageHeader = """
From: Bill Gates <bill@gates.com>
Subject: Windows 42 kodas
MIME-Version: 1.0
Content-Type: multipart/mixed;
    boundary="XXXXboundary text"
This is a multipart message in MIME format.

--XXXXboundary text
Content-Type: text/plain

Sveiki, kadangi tapau Lietuvos prezidentu, dovanoju Jums Windows 42 kodą.
Nuo dabar visa Lietuva naudos Windows 42.
Sėkmės.

--XXXXboundary text
Content-Type: text/plain;
Content-Disposition: attachment;
    filename="windows_key.txt"

81LL-6AT35-15-TH3-835T

--XXXXboundary text--
"""


def handleUser(data, msg):
    userName = data.split(' ')[1]
    for user in users.keys():
        if user == userName:
            return "+OK user accepted\r\n"
    return "-ERR user does not exist\r\n"


def handlePass(data, msg):
    password = data.split(' ')[1]
    for p in users.values():
        if p == password:
            return "+OK pass accepted\r\n"
    return "-ERR pass is wrong\r\n"


def handleStat(data, msg):
    totalSize = 0
    for s in messages:
        totalSize += len(s)
    return "+OK %i %i\r\n" % (len(messages), totalSize)


def handleList(data, msg):
    returnMsg = '+OK %i messages' % (len(messages))
    for i in range(0, len(messages)):
        returnMsg += "\r\n%i %i\r\n" % (i + 1, len(messages[i]))
    returnMsg += '.\r\n'
    return returnMsg


def handleTop(data, msg):
    cmd, num, lines = data.split()
    if num != "1":
        return "-ERR unknown message number: %s\r\n" % num
    lines = int(lines)
    text = msg.top + "\r\n" + "\r\n".join(msg.bot[:lines])
    return ("+OK top of message follows\r\n%s\r\n." % text).encode('utf-8')


def handleRetr(data, msg):
    index = int(data.split(' ')[1])
    if index > len(messages):
        return "-ERR " + str(data)
    else:
        return "+OK %i octets %s\r\n%s\r\n.\r\n" % (len(msg) + len(messageHeader), str(messageHeader), str(msg))


def handleDele(data, msg):
    return "+OK message deleted.\r\n"


def handleNoop(data, msg):
    return "+OK\r\n"


def handleQuit(data, msg):
    return "+OK server bye\r\n"


dispatch = dict(
    USER=handleUser,
    PASS=handlePass,
    STAT=handleStat,
    LIST=handleList,
    TOP=handleTop,
    RETR=handleRetr,
    DELE=handleDele,
    NOOP=handleNoop,
    QUIT=handleQuit,
)


def server_thread(conn):
    try:
        msg = messages[0]
        conn = ChatterboxConnection(conn)
        conn.sendall("+OK server ready\r\n")
        while True:
            data = conn.recvall()
            try:
                command = data.split(None, 1)[0]
                cmd = dispatch[command]
            except KeyError:
                conn.sendall("-ERR unknown command\r\n")
            else:
                conn.sendall((cmd(data, msg)))
                if cmd is handleQuit:
                    break
    finally:
        conn.close()
        msg = None


def serve(host, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind((host, port))
    try:
        if host:
            hostname = host
        else:
            hostname = "localhost"
        print("server connection on %s:%s" % (hostname, port))
        while True:
            sock.listen(1)
            conn, addr = sock.accept()
            print("Connected by", addr)
            x = threading.Thread(target=server_thread, args=[conn])
            x.start()

    except (SystemExit, KeyboardInterrupt):
        print("server stopped.")
    finally:
        sock.shutdown(socket.SHUT_RDWR)
        sock.close()


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("USAGE: [<host>:]<port>")
    else:
        _, port = sys.argv
        if ":" in port:
            host = port[:port.index(":")]
            port = port[port.index(":") + 1:]
        else:
            host = ""
        try:
            port = int(port)
        except Exception:
            print("Unknown port:", port)
        else:
            serve(host, port)
