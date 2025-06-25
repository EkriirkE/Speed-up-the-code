$avg=0
foreach($test in 0..10) {
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

if (0) {
	$x=0
	for($i=0;$i -lt 500000;$i++){#600,000
		$x += 1
	}
}
if (0) {
	$x=0
	Foreach($i in 0..499999) {#500,000
		$x += 1
	}
}
if (0) {
	$x=0
	(0..499999).ForEach({#1,200,000
		$x += 1
	})
}
if(0){#10,800,000
	$g=@()
	for($i=0;$i -lt 50000;$i++){
		$x += 1
		$g+="String $x"
	}
}
if(0){#110,000
	$g=[String[]]::new(50000)
	for($i=0;$i -lt 50000;$i++){
		$x += 1
		$g[$i]="String " + $x
	}
}
if(0){#130,000
	$g=[System.Collections.Generic.List[String]]@()
	for($i=0;$i -lt 50000;$i++){
		$x += 1
		$g.Add("String " + $x)
	}
}
if(0){#120,000
	$g=[System.Collections.Generic.List[String]]::New(50000)
	for($i=0;$i -lt 50000;$i++){
		$x += 1
		$g.Add("String " + $x)
	}
}
if(0){#120,000
	$g=[System.Collections.ArrayList]@()
	for($i=0;$i -lt 50000;$i++){
		$x += 1
		[void]$g.Add("String " + $x)
	}
}

if(0){
	ForEach($i in 0..99) {
		[System.Console]::WriteLine("PLC log file generated.")	#800
	}
}
if(0){
	ForEach($i in 0..99) {
		"PLC log file generated."	#3100
	}
}
if(0){
	ForEach($i in 0..99) {
		Write-Host "PLC log file generated."	#10,000
	}
}

if(1){
	for($i=0;$i -lt 50000;$i++){
		$g=@(1,2,3,4,5,6,7,8,9,0)#6,800
		#$g=1,2,3,4,5,6,7,8,9,0#7,200
		#$g=[System.Collections.ArrayList]@(1,2,3,4,5,6,7,8,9,0)#8,000
		#$g=[System.Collections.Generic.List[int]]@(1,2,3,4,5,6,7,8,9,0)#10,000
		$g[0]=$g[1]
	}
}

if(0){
	$g=[String[]]::new(50000)
	ForEach($i in 0..49999) {
		$x += 1
		$in=$x*3
		$g[$i]="String $in"	#100,000
		#$g[$i]="String {0}" -f $x	#130,000
		#$g[$i]="String " + $x	#100,000
	}
}

# all results end up in the array:
$avg=+$stopwatch.Elapsed.TotalMicroseconds
}
$avg/$test