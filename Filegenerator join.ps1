Measure-Command{
$pa='PLC_A','PLC_B','PLC_C','PLC_D'
$ea='Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning'
$sa='OK','WARN','ERR'

$g=[String[]]::new(50000)
$bt=Get-Date
$r=New-Object System.Random
(0..49999).ForEach({
	$x=$r.Next()
	$o="INFO",$bt.AddSeconds(-$_).ToString("yyyy-MM-dd HH:mm:ss"),$pa[$x%4],"System running normally","",$sa[$x%3],($x%20)+101,($x%101)+1000,($x%50)+60,($x%101)
	if(!($x%7)){
		$o[0]="ERROR"
		if(!($e=($seed%4))){$o[4]=$x%10+1}
		$o[3]=$ea[$e]
	}
	$g[$_]=$o -Join "; "
})

[IO.File]::WriteAllBytes( "plc_log.txt",[Byte[]]$g)
#Out-File "plc_log.txt" -Encoding utf8 -InputObject $g
#Set-Content "plc_log.txt" $g
[Console]::WriteLine("PLC log file generated.")
}