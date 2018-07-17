param (
    [string]$size,
    [string]$origin
)

# https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/cli-chap-getting-started.html

# 관리자 권한으로 실행해주세요
# Set-ExecutionPolicy Bypass -Scope Process -Force; ./convert.ps1

# Check AWSCLI was installed
try {
    if (Get-Command aws) {
        Write-Host "There is AWS CLI"
    }
}
catch {
    try 
    {
        Get-Command choco;
    } 
    catch 
    {
        # install choco
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    } 
    finally
    {
        choco install awscli -y
    }
}

$current = (Get-Location).Path
$env:Path += ";$current/lib/ffmpeg/bin"

$arr = $origin.Split('.')
$arr = $arr[0..($arr.Count-2)]

$new = $arr -join "."

New-Item  -ItemType Directory -Path "./bin/$new"

ffmpeg -i $origin -profile:v baseline -level 3.0 -s $size -start_number 0 -hls_time 10 -hls_list_size 0 -f hls "./bin/$new/index.m3u8"

# aws configure 로 세팅을 해준 상태라는 것을 가정합니다
aws s3 sync "./bin/$new/" "s3://hls-vr-video-bukkit/$new/"

# Remove Remove things
Remove-Item -Path ./bin/*