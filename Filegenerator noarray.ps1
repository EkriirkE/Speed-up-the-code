Measure-Command{
$pa=@('PLC_A','PLC_B','PLC_C','PLC_D')
$ea=@('Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning')
$sa=@('OK','WARN','ERR')

$g=[System.Text.StringBuilder]""
$d=Get-Date	#Prefetch the date once
$r=New-Object System.Random	#Faster than Get-Random
ForEach ($i in 0..49999){	#Faster than for(;;) or (x..y).ForEach.  Do I dare to unrill the loop :o
	$x=$r.Next()	#Get a random number for further pseudo-pseudo random extractions.  Output is still random.
	#Shorten var names for faster parsing in "$x $y $z"
	$t=$d.AddSeconds(-$i).ToString("yyyy-MM-dd HH:mm:ss")	#IDK what to speed up here
	$p=$pa[$x%4]
	$o=$x%20+101
	$b=$x%101+1000
	$s=$sa[$x%3]
	$x=$r.Next()	#Need to refresh because we already extract %101
	$m=$x	#Your sample is just a large random int so that is what you get, but I think the intention was this? $x%5000/100+60
	$l=$x%101
	if($x%7){	#6:7 chance of normality
		$g.AppendLine("INFO; $t; $p; System running normally; ; $s; $o; $b; $m; $l")
	}elseif($e=($r.Next()%4)){	#3:4 chance not being Sandextrator overload - Must be actual new value as %4 and %7 dont play nice
		$e=$ea[$e]
		$g.AppendLine("ERROR; $t; $p; $e; ; $s; $o; $b; $m; $l")
	}else{
		$e=$ea[$e]
		$v=$x%10+1	#Seems faster to assign to var first than explicit $($x%10+1) in string, I guess precompile vs runtime char parsing
		$g.AppendLine("ERROR; $t; $p; $e; $v; $s; $o; $b; $m; $l")
	}
}
[System.IO.File]::WriteAllBytes("$PWD\plc_log.txt",[System.Text.Encoding]::UTF8.GetBytes($g))	#Seems faster than Out-File and Set-Content
[System.Console]::WriteLine("PLC log file generated.")	#Faster than Write-Output and Write-Host
}