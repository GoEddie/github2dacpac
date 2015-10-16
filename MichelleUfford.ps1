


Function get-code{

    if(!(Test-Path -Path sql-scripts )){
        git clone https://github.com/MichelleUfford/sql-scripts
    }
    
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
  
    build-dacpac "90" "/sp=sql-scripts=*sp*.sql /sv=Sql90  /dp=.\output\90\michelleuford.dacpac /ref=master=master.dacpac /fix";
    build-dacpac "100" "/sp=sql-scripts=*sp*.sql /sv=Sql100  /dp=.\output\100\michelleuford.dacpac /ref=master=master.dacpac /fix";
    build-dacpac "110" "/sp=sql-scripts=*sp*.sql /sv=Sql110  /dp=.\output\110\michelleuford.dacpac /ref=master=master.dacpac /fix";
    build-dacpac "120" "/sp=sql-scripts=*sp*.sql /sv=Sql120  /dp=.\output\120\michelleuford.dacpac /ref=master=master.dacpac /fix";
}

get-code

#get-dir2dac

#extract-zip (Get-Item -Path ".\" -Verbose).FullName + "\bin\dir2dac.zip", (Get-Item -Path ".\" -Verbose).FullName + "\bin\dir2dac"

build-dacpacs 
