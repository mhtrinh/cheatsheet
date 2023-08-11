# Read line by line from a file:
``` 
exec 9< "$tempFile"
while IFS= read -r -u 9 line
do    
    echo $line
done
```

# Read line by line through a variable:
```
while IFS='' read -r found <&9 || [[ -n "$found" ]]; 
do
    echo $found
done 9< <(echo "$myVariable")
```
