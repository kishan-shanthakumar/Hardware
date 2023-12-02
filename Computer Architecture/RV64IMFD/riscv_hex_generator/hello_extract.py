num = 1

fil = open('rom.vh')
lines = fil.readlines()
li = []
outfiles = [open('mem_ram.hex','w')]

for i in lines:
	if not i[0] == '@':
		li.extend(i.split())
while(len(li)%(4*int(num)) != 0):
    li.append('00')
i = 0
while i < len(li):
    for j in range(int(num)):
        outfiles[j].write(li[i+3]+li[i+2]+li[i+1]+li[i]+'\n')
        i = i + 4