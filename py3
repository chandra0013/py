list=["bhuvi","ashwin","virat","nehra","pan parag"]
list[4]="Sachin"
print(list)
list.insert(2,"dhoni")
print(list)
list.append("tilak varma")
print(list)
list2=["sunil gavaskar","saurav ganguly","sehwag","raina","broad"]
list.extend(list2[1],[2])
print(list)
listt=[]
n=int(input("enter the number of items in the list"))
for i in range(n):
    listt.append(input("enter item name"))
print(listt)
listt.remove("lmao")
print(listt)
del listt
print(listt) #error comes since list is deleted
listt=[]
n=int(input("enter the number of items in the list"))
for i in range(n):
    listt.append(input("enter friend name"))
print(listt[0],listt[n-1])
thislist = ["apple", "banana", "cherry"]
[print(x) for x in thislist]
lost=list(range(0,100,2))
print(lost)
list=[]
n=int(input("enter n"))
for i in range(n):
   lol=int(input("enter marks:"))
   list.append(lol)
print(list)
sum=0
i=0

for i in range(n):
    sum=list[i]+sum
ca=sum/n
print(ca)
i=0

lol=0
lmao=0
pl=0
for i in range(n):
    if(i==0):
    lol+=1
    elif(i<=0):
    lmao+=1
    else
    pl+=1
print(lol,lmao,pl)



list1=[]
n=int(input("enter n"))
for i in range(n):
   lol=int(input("enter num:"))
   list1.append(lol)
print(list1)
k=0
for k in range(n):
    if(sum(list1[0:k])==sum(list1[k+1:n])):
        print(k)
    

