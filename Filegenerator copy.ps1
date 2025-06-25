Measure-Command{
$pa='PLC_A','PLC_B','PLC_C','PLC_D'
$ea='Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning'
$sa='OK','WARN','ERR'

$g=[String[]]::new(50000)
$bt=Get-Date
$r=New-Object System.Random
(0..49999).ForEach({
	$t=$bt.AddSeconds(-$_).ToString("yyyy-MM-dd HH:mm:ss")
	$x=$r.Next()
	$p=$pa[$x%4]
	$o=$x%20+101
	$b=$x%101+1000
	$s=$sa[$x%3]
	$m=$x%50+60
	$l=$x%101
	if($x%7){$g[$_]=("INFO; $t; $p; System running normally; ; $s; $o; $b; $m; $l")}elseif($e=($seed%4)){$g[$_]=?"ERROR; $t; $p; $e; ; $s; $o; $b; $m; $l"}else{$g[$_]="ERROR; $t; $p; $($ea[$e]); $($x%10+1); $s; $o; $b; $m; $l"}
})

Set-Content -Path "plc_log.txt" -Value $g
Write-Output "PLC log file generated."
}