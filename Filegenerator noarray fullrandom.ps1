Measure-Command{
#@(,,,) seems faster than ,,, somehow?
$plcNames=@('PLC_A','PLC_B','PLC_C','PLC_D')
$errorTypes=@('Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning')
$statusCodes=@('OK','WARN','ERR')

$date=Get-Date	#Prefetch the date once
$random=New-Object System.Random	#Faster than Get-Random
$output=[System.Text.StringBuilder]""
ForEach ($_ in 0..49999){	#Faster than for(;;) or (x..y).ForEach.  Do I dare to unroll the loop :o
	$timestamp=$date.AddSeconds(-$i).ToString("yyyy-MM-dd HH:mm:ss")	#IDK what to speed up here
	$plc=$plcNames[$random.Next()%4]
	$operator=$random.Next()%20+101
	$batch=$random.Next()%101+1000
	$status=$statusCodes[$random.Next()%3]
	$machineTemp=$random.Next()	#Your sample is just a large random int so that is what you get, but I think the intention was this? $random.Next()%5000/100+60
	$load=$random.Next()%101
	if($random.Next()%7){	#6:7 chance of normality
		$output.AppendLine("INFO; {0}; {1}; System running normally; ; {2}; {3}; {4}; {5}; {6}" -f ($timestamp,$plc,$status,$operator,$batch,$machineTemp,$load))
	}elseif($errorType=($random.Next()%4)){	#3:4 chance not being Sandextrator overload - Must be actual new value as %4 and %7 dont play nice
		$output.AppendLine("ERROR; {0}; {1}; {2}; ; {3}; {4}; {5}; {6}; {7}" -f ($timestamp,$plc,$errorTypes[$errorType],$status,$operator,$batch,$machineTemp,$load))
	}else{
		$output.AppendLine("ERROR; {0}; {1}; {2}; {3}; {4}; {5}; {6}; {7}; {8}" -f ($timestamp,$plc,$errorTypes[$errorType],($random.Next()%10+1),$status,$operator,$batch,$machineTemp,$load))
	}
}
[System.IO.File]::WriteAllBytes("$PWD\plc_log.txt",[System.Text.Encoding]::UTF8.GetBytes($output))	#Seems faster than Out-File and Set-Content
[System.Console]::WriteLine("PLC log file generated.")	#Faster than Write-Output and Write-Host
}