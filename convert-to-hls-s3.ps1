param (
    [parameter(Mandatory=$true)]
    [string]$Size,
    [parameter(Mandatory=$true)]
    [string]$Path
)

# https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/cli-chap-getting-started.html

# 관리자 권한으로 실행해주세요
# Set-ExecutionPolicy Bypass -Scope Process -Force; ./convert.ps1

$current = (Get-Location).Path
$env:Path += ";$current/lib/ffmpeg/bin"

# Get Filename
$file_tree = $Path.Replace('/','\').Split('\')
$filename = $file_tree[$file_tree.Count - 1]

$arr = $filename.Split('.')
$arr = $arr[0..($arr.Count-2)]

$new = $arr -join "."

New-Item  -ItemType Directory -Path "./bin/$new"

ffmpeg -i $origin -profile:v baseline -level 3.0 -s $Size -start_number 0 -hls_time 10 -hls_list_size 0 -f hls "./bin/$new/index.m3u8"

# aws configure 로 세팅을 해준 상태라는 것을 가정합니다
aws s3 sync "./bin/$new/" "s3://hls-vr-video-bukkit/$new/"

# Remove Remove things
Remove-Item -Path ./bin/*