os.execute("cls")
print("cleaning terminal logs...")
for i = 1,200 do
    io.write("\27[1A")
end
for i = 1,200 do
    print("\rLINE REMOVED: #########################################")
end
print("cleaned!")
os.execute("clear")