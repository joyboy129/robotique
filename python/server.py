import serial
import socket
import threading
# Connect to Arduino
ser = serial.Serial('COM18', 9600,timeout=1)

# Set up socket server
host = '127.0.0.1'
port = 5000
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((host, port))
server_socket.listen(1)


print('Waiting for connection...')
conn, addr = server_socket.accept()
print('Connected by', addr)


HOST = ''  
PORT = 5000  

while True:
    try :
        data = ser.readline().strip()
        data_str = str(data)
        conn.send(data_str.encode())
        conn.settimeout(1.0)
        data = conn.recv(512)
        if data:
            ser.write(data)
            print(data)
        
    except Exception as e:
        pass
