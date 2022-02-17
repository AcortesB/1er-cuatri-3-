
import os
import sys
import subprocess

def execute(cmd):
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, error = p.communicate() # Esperem que acabi la comanda
    return output, error, p.returncode

def usage():
    print("Usage: ocupacio.py [-g grup] <max permes>")
    exit(1)

def espai_llegible(user, espai):
    if espai > 1024*1024*1024:
        print("{} {:.0f}G".format(user, espai/(1024*1024*1024)))
    if espai > 1024*1024:
        print("{} {:.0f}M".format(user, espai/(1024*1024)))
    elif espai > 1024:
        print("{} {:.0f}K".format(user, espai/1024))
    else:
        print("{} {:.0f}B".format(user, espai))

# Si los parametros no son los acordados damos error
if len(sys.argv) != 2 and len(sys.argv) != 4:
    usage()

max_usage=sys.argv[1]
users=execute("cut -d: -f1 /etc/passwd")[0].decode('utf-8').split("\n")

groups=False
if len(sys.argv) == 4:
    if sys.argv[1] == "-g":
        groups=True
        grup_name=sys.argv[2]
        max_usage=sys.argv[3]
        # Llista de usuaris del grup
        users=execute("cat /etc/group | grep {} | cut -d ':' -f4 | tr ',' ' '".format(grup_name))[0].decode('utf-8').split()

max_num=int(max_usage[0:-1])
# Pasem max_num a bytes
if max_usage[-1] == "K":
   max_num=max_num*1024
if max_usage[-1] == "M":
    max_num=max_num*1024*1024
if max_usage[-1] == "G":
    max_num=max_num*1024*1024*1024

total_grup=0
for user in users:
    if user != '':
        home=execute("cat /etc/passwd | grep '^{}\>' | cut -d : -f6".format(user))[0].split()[0].decode('utf-8')
        if os.path.isdir(home): 
            espai=int(execute("du -cbhsx -k {} 2> /dev/null | grep 'total' | awk '{{print $1}}'".format(home))[0])

            # Si el usuari es pasa del maxim especificat per parametre se'l avisa per el seu .profile
            if espai > max_num:
                try:
                    with open("{}/.profile".format(home), "a") as f:
                        f.write("echo 'Estas ocupant molt de disc, elimina fichers amb la comanda rm'\n")
                        f.write("echo 'Per eliminar aquest missatge elimina les ultimes 2 lines del teu .profile'\n")
                except:
                    pass

            # mostra el espai de cada usuari
            espai_llegible(user, espai)

            if groups:
                total_grup+=espai


# Mostrem el total per el grup especificat si cal
if groups:
    print("\nTOTAL: ")
    espai_llegible(grup_name,total_grup)
