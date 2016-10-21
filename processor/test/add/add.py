import string
f = open("add_tracefile.txt",'w')
string=""
for i in range(2**8):
	for j in range(2**8):
		string=""
		string+='{:016b}'.format(2*i+1) + " " +  '{:016b}'.format(2*j+1) + " " + '{:017b}'.format(2*i+2*j+2) +"\n"
		f.write(string)

