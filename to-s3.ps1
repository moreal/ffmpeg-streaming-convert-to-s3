param (
    [parameter(Mandatory=$true)]
    [string]$Path
)

# Get Filename
$file_tree = $Path.Replace('/','\').Split('\')
$filename = $file_tree[$file_tree.Count - 1]

aws s3 cp $Path "s3://origin-vr-video-bukkit/$filename"