Measure-Command{
$work=@{
	#@(,,,) seems faster than ,,, somehow?
	pa=@('PLC_A','PLC_B','PLC_C','PLC_D')
	ea=@('Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning')
	sa=@('OK','WARN','ERR')

	chk=@((0..9999),(10000..19999),(20000..29999),(30000..39999),(40000..49999))
	g=[String[]]::new(50000)	#Pre-allocate output array, then index it.  No speed diff noticed vs [System.Collections.ArrayList].Add()
	d=Get-Date	#Prefetch the date once
	r=New-Object System.Random	#Faster than Get-Random
}

0..4 | ForEach-Object -Parallel {
	$w=$using:work
	ForEach ($i in $w.chk[$_]){
		$x=$w.r.Next()	#Get a random number for further pseudo-pseudo random extractions.  Output is still random.
		#Shorten var names for faster parsing in "$x $y $z"
		$t=$w.d.AddSeconds(-$i).ToString("yyyy-MM-dd HH:mm:ss")	#IDK what to speed up here
		$p=$w.pa[$x%4]
		$o=$x%20+101
		$b=$x%101+1000
		$s=$w.sa[$x%3]
		$x=$w.r.Next()	#Need to refresh because we already extract %101
		$m=$x	#Your sample is just a large random int so that is what you get, but I think the intention was this? $x%5000/100+60
		$l=$x%101
		if($x%7){	#6:7 chance of normality
			$w.g[$i]="INFO; {0}; {1}; System running normally; ; {2}; {3}; {4}; {5}; {6}" -f ($t,$p,$s,$o,$b,$m,$l)
		}elseif($e=($w.r.Next()%4)){	#3:4 chance not being Sandextrator overload - Must be actual new value as %4 and %7 dont play nice
			$w.g[$i]="ERROR; {0}; {1}; {2}; ; {3}; {4}; {5}; {6}; {7}" -f ($t,$p,$w.ea[$e],$s,$o,$b,$m,$l)
		}else{
			$w.g[$i]="ERROR; {0}; {1}; {2}; {3}; {4}; {5}; {6}; {7}; {8}" -f ($t,$p,$w.ea[$e],($x%10+1),$s,$o,$b,$m,$l)
		}
	}
}

[System.IO.File]::WriteAllBytes("$PWD\plc_log.txt",[System.Text.Encoding]::UTF8.GetBytes($work.g -Join "`n"))	#Seems faster than Out-File and Set-Content
[System.Console]::WriteLine("PLC log file generated.")	#Faster than Write-Output and Write-Host
}