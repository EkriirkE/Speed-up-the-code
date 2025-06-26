# Speed-up-the-code

Speed up the code competition / PSCONFEU 2025
More info on https://bepug.odoo.com/speed-up-the-code

The original code has a logic/data error with `$machineTemp = [math]::Round((Get-Random -Minimum 60 -Maximum 110) + (Get-Random),2)`

Get-Random without parameters returns a full Int32, not 0~1.0f as other implementations
So adding this result just gives you the fat int.
We can either change the params to return such a float `[math]::Round((Get-Random -Minimum 60 -Maximum 110) + (Get-Random -Minimum 0.0 -Maximum 1.0),2)`
Or adjust the original ranges *100, then divide by 100 and omit the roudning `(Get-Random -Minimum 6000 -Maximum 11000)/100`

And, of course, save some cycles by doing our own maths instead of pushing parameters `$random.Next()%5000/100+60`
