$g=[System.Text.StringBuilder]""
ForEach ($_ in 0..49){
	[void]$g.AppendLine(@"
`$t=`$d.AddSeconds(-$_).ToString("yyyy-MM-dd HH:mm:ss");`$p=`$pa[`$r.Next()%4];`$o=`$r.Next()%20+101;`$b=`$r.Next()%101+1000;`$s=`$sa[`$r.Next()%3];`$m=`$r.Next();`$l=`$r.Next()%101
	if(`$r.Next()%7){`$g.AppendLine("INFO; `$t; `$p; System running normally; ; `$s; `$o; `$b; `$m; `$l")}elseif(`$e=(`$r.Next()%4)){`$e=`$ea[`$e];`$g.AppendLine("ERROR; `$t; `$p; `$e; ; `$s; `$o; `$b; `$m; `$l")}else{`$e=`$ea[`$e];`$v=`$r.Next()%10+1;`$g.AppendLine("ERROR; `$t; `$p; `$e; `$v; `$s; `$o; `$b; `$m; `$l")}
"@)
}
[System.IO.File]::WriteAllBytes("$PWD\Filegenerator unrolled2.ps1",[System.Text.Encoding]::UTF8.GetBytes($g))	#Seems faster than Out-File and Set-Content
