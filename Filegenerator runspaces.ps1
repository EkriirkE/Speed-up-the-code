Measure-Command{
$work=@{
	#@(,,,) seems faster than ,,, somehow?
	pa=@('PLC_A','PLC_B','PLC_C','PLC_D')
	ea=@('Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning')
	sa=@('OK','WARN','ERR')

	g=[String[]]::new(50000)	#Pre-allocate output array, then index it.  No speed diff noticed vs [System.Collections.ArrayList].Add()
	d=Get-Date	#Prefetch the date once
	r=New-Object System.Random	#Faster than Get-Random
}

$PS={
Param (
[int]$a,#Start range
[int]$b,#Stop range
$w
)
	[System.Console]::WriteLine("$a to $b $($w.t)")
	ForEach ($i in $a..$b){	#Faster than for(;;) or (x..y).ForEach.  Do I dare to unrill the loop :o
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
			$w.g[$i]="INFO; $t; $p; System running normally; ; $s; $o; $b; $m; $l"
		}elseif($e=($w.r.Next()%4)){	#3:4 chance not being Sandextrator overload - Must be actual new value as %4 and %7 dont play nice
			$e=$w.ea[$e]
			$w.g[$i]="ERROR; $t; $p; $e; ; $s; $o; $b; $m; $l"
		}else{
			$e=$w.ea[$e]
			$v=$x%10+1	#Seems faster to assign to var first than explicit $($x%10+1) in string, I guess precompile vs runtime char parsing
			$w.g[$i]="ERROR; $t; $p; $e; $v; $s; $o; $b; $m; $l"
		}
	}
}

#I read runspaces are multithreading vs jobs being new processes is faster on the internet.  So it must be true?
$cc=[int]$env:NUMBER_OF_PROCESSORS
$pool=[RunspaceFactory]::CreateRunspacePool(1,$cc+1)
$pool.Open()

$mx=50000
$c=[System.Math]::Round($mx/$cc)	#ChunkSize
$th=[System.Collections.ArrayList]@()#I dont feel like precalculating like above, so lets use the alternative NET array
While($mx -gt 0){
	#Write-Host "$([System.Math]::Max(0,$mx-$c)) to $($mx-1)"
	$r=[PowerShell]::Create()
	[void]$r.AddScript($PS)
	[void]$r.AddArgument([System.Math]::Max(0,$mx-$c))
	[void]$r.AddArgument($mx-1)
	[void]$r.AddArgument([ref]$work)
	$r.RunspacePool=$pool
	$th.Add([PSCustomObject]@{Pipe=$r;Status=$r.BeginInvoke()})
	$mx-=$c
}#Might get a remainder thrown in a CPU+1 thread.  Naja

#Stolen cleanup clode
while($th.Status.IsCompleted -notcontains $true){}
$th.ForEach({
	[void]$_.Pipe.EndInvoke($_.Status)
	$_.Pipe.Dispose()
})
$pool.Close()
$pool.Dispose()

[System.IO.File]::WriteAllBytes("$PWD\plc_log.txt",[System.Text.Encoding]::UTF8.GetBytes($g -Join "`n"))	#Seems faster than Out-File and Set-Content
[System.Console]::WriteLine("PLC log file generated.")	#Faster than Write-Output and Write-Host
}