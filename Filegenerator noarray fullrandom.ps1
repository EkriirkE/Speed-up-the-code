Measure-Command{
$pa=@('PLC_A','PLC_B','PLC_C','PLC_D')
$ea=@('Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning')
$sa=@('OK','WARN','ERR')

$g=[System.Text.StringBuilder]""
$d=Get-Date	#Prefetch the date once
$r=New-Object System.Random	#Faster than Get-Random
ForEach ($_ in 0..49999){	#Faster than for(;;) or (x..y).ForEach.  Do I dare to unrill the loop :o
	#Shorten var names for faster parsing in "$r.Next() $y $z"
	$t=$d.AddSeconds(-$_).ToString("yyyy-MM-dd HH:mm:ss")	#IDK what to speed up here
	$p=$pa[$r.Next()%4]
	$o=$r.Next()%20+101
	$b=$r.Next()%101+1000
	$s=$sa[$r.Next()%3]
	$m=$r.Next()	#Your sample is just a large random int so that is what you get, but I think the intention was this? $r.Next()%5000/100+60
	$l=$r.Next()%101
	if($r.Next()%7){	#6:7 chance of normality
		$g.AppendLine("INFO; $t; $p; System running normally; ; $s; $o; $b; $m; $l")
	}elseif($e=($r.Next()%4)){	#3:4 chance not being Sandextrator overload - Must be actual new value as %4 and %7 dont play nice
		$e=$ea[$e]
		$g.AppendLine("ERROR; $t; $p; $e; ; $s; $o; $b; $m; $l")
	}else{
		$e=$ea[$e]
		$v=$r.Next()%10+1	#Seems faster to assign to var first than explicit $($r.Next()%10+1) in string, I guess precompile vs runtime char parsing
		$g.AppendLine("ERROR; $t; $p; $e; $v; $s; $o; $b; $m; $l")
	}
}
[System.IO.File]::WriteAllBytes("$PWD\plc_log.txt",[System.Text.Encoding]::UTF8.GetBytes($g))	#Seems faster than Out-File and Set-Content
[System.Console]::WriteLine("PLC log file generated.")	#Faster than Write-Output and Write-Host
}