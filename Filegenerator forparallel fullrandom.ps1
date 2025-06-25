Measure-Command{
$work=@{
	#@(,,,) seems faster than ,,, somehow?
	plcNames=@('PLC_A','PLC_B','PLC_C','PLC_D')
	errorTypes=@('Sandextrator overload','Conveyor misalignment','Valve stuck','Temperature warning')
	statusCodes=@('OK','WARN','ERR')

	chunks=@((0..9999),(10000..19999),(20000..29999),(30000..39999),(40000..49999))
	output=[String[]]::new(50000)	#Pre-allocate output array, then index it.  No speed diff noticed vs [System.Collections.ArrayList].Add()
	date=Get-Date	#Prefetch the date once
	random=New-Object System.Random	#Faster than Get-Random
}

0..4 | ForEach-Object -Parallel {
	$work=$using:work
	ForEach ($i in $work.chunks[$_]){
		$timestamp=$work.date.AddSeconds(-$i).ToString("yyyy-MM-dd HH:mm:ss")	#IDK what to speed up here
		$plc=$work.plcNames[$work.random.Next()%4]
		$operator=$work.random.Next()%20+101
		$batch=$work.random.Next()%101+1000
		$status=$work.statusCodes[$work.random.Next()%3]
		$machineTemp=$work.random.Next()	#Your sample is just a large random int so that is what you get, but I think the intention was this? $work.random.Next()%5000/100+60
		$load=$work.random.Next()%101
		if($work.random.Next()%7){	#6:7 chance of normality
			$work.output[$i]="INFO; {0}; {1}; System running normally; ; {2}; {3}; {4}; {5}; {6}" -f ($timestamp,$plc,$status,$operator,$batch,$machineTemp,$load)
		}elseif($errorType=($work.random.Next()%4)){	#3:4 chance not being Sandextrator overload
			$work.output[$i]="ERROR; {0}; {1}; {2}; ; {3}; {4}; {5}; {6}; {7}" -f ($timestamp,$plc,$work.errorTypes[$errorType],$status,$operator,$batch,$machineTemp,$load)
		}else{
			$work.output[$i]="ERROR; {0}; {1}; {2}; {3}; {4}; {5}; {6}; {7}; {8}" -f ($timestamp,$plc,$work.errorTypes[$errorType],($work.random.Next()%10+1),$status,$operator,$batch,$machineTemp,$load)
		}
	}
}

[System.IO.File]::WriteAllBytes("$PWD\plc_log.txt",[System.Text.Encoding]::UTF8.GetBytes($work.output -Join "`n"))	#Seems faster than Out-File and Set-Content
[System.Console]::WriteLine("PLC log file generated.")	#Faster than Write-Output and Write-Host
}