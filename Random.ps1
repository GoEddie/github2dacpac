

Function get-downloads{
    
    if(!(Test-Path -Path .\src )){
        mkdir .\src | Out-Null
    }
   
   Invoke-WebRequest https://gist.githubusercontent.com/edeustace/2377468/raw/31a552a8564578cdb5cd48b468515e5bd4b4669c/sp.AutoGenerateAuditTableAndTrigger.sql -outfile ".\src\audit_table.sql"
   Invoke-WebRequest http://media.tomaslind.net/2013/10/GetTempdbMaxSize.txt -outfile ".\src\GetTempdbMaxSize.sql"
   
    
}

Function get-dir2dac {

    if(!(Test-Path -Path .\bin )){
        mkdir .\bin | Out-Null
    }
   
   Invoke-WebRequest https://github.com/GoEddie/Dir2Dac/blob/master/release/Dir2Dac.0.1.zip?raw=true -outfile ".\bin\dir2dac.zip"
}

Function extract-zip ($sourceFile, $outputFolder) {
    if(!(Test-Path -Path $outputFolder)){
        Add-Type -assembly "system.io.compression.filesystem"

        Write-Host $sourceFile
        Write-Host $outputFolder

        [io.compression.zipfile]::ExtractToDirectory($sourceFile, $outputFolder)
    }
}

Function build-dacpac ($sqlVersion, $arguments)
    {
    
    Write-Host $sqlVersion
    #create output folder
   
    if(!(Test-Path -Path .\output )){
        mkdir .\output | Out-Null
    }

    $outPath = ".\output\" + $sqlVersion

    if(!(Test-Path -Path $outPath )){
        mkdir $outPath | Out-Null
    }

    #get master version that we need

    $url = "https://github.com/GoEddie/DacPac-SystemDatabases/blob/master/dacpacs/" + $sqlVersion + "/SQLSchemas/master.dacpac?raw=true"
    $outFile = $outPath + "\master.dacpac"


    Invoke-WebRequest -Uri $url -outFile $outFile

        
    
    Start-Process .\bin\dir2dac\Dir2Dac.exe -wait -argument $arguments
     

}


Function build-dacpacs (){
    
    build-dacpac "90" "/sp=src /sv=Sql90  /dp=.\output\90\admin.dacpac /ref=master=master.dacpac /fix";
    build-dacpac "100" "/sp=src /sv=Sql100  /dp=.\output\100\admin.dacpac /ref=master=master.dacpac /fix";
    build-dacpac "110" "/sp=src /sv=Sql110  /dp=.\output\110\admin.dacpac /ref=master=master.dacpac /fix";
    build-dacpac "120" "/sp=src /sv=Sql120  /dp=.\output\120\admin.dacpac /ref=master=master.dacpac /fix";
}

#get-code
get-downloads

#get-dir2dac

#extract-zip (Get-Item -Path ".\" -Verbose).FullName + "\bin\dir2dac.zip", (Get-Item -Path ".\" -Verbose).FullName + "\bin\dir2dac"

build-dacpacs 
