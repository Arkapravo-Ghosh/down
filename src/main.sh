#!/data/data/com.termux/files/usr/bin/bash
display_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo "Options:"
    echo "  -h, --help       Display this help message"
    echo "  -u, --url URL    Specify the share URL of the video"
    echo ""
    echo "down v1.0.3 Made by Arkapravo Ghosh"
}
download_video() {
    video_url=$(yt-dlp --no-playlist --get-url "$1")
    if [[ -n $video_url ]]; then
        filename=$(basename "$video_url" | cut -d'?' -f1)
        download_dir="$HOME/storage/downloads"
        wget -O "$download_dir/$filename" "$video_url"
        exiftool -overwrite_original -FileModifyDate="$(date +"%Y:%m:%d %H:%M:%S")" "$download_dir/$filename"
        am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d "file://$download_dir/$filename"
    else
        echo "Failed to retrieve video URL."
    fi
}
if [[ $1 == "-h" || $1 == "--help" ]]; then
    display_help
    exit 0
fi
if ! command -v yt-dlp &>/dev/null; then
    echo "yt-dlp is not installed. Please install it using 'pip install yt-dlp' and try again."
    exit 1
fi
if ! command -v wget &>/dev/null; then
    echo "wget is not installed. Please install it using 'pkg install wget' and try again."
    exit 1
fi
if ! command -v exiftool &>/dev/null; then
    echo "exiftool is not installed. Please install it using 'pkg install exiftool' and try again."
    exit 1
fi
if ! command -v am &>/dev/null; then
    echo "am is not installed. Please install it using 'pkg install termux-tools' and try again."
    exit 1
fi
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -u|--url)
            share_url="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done
if [[ -z $share_url ]]; then
    read -p "Enter URL: " share_url
fi
if [[ $share_url == *"youtube.com"* ]]; then
    download_video "$share_url"
elif [[ $share_url == *"youtu.be"* ]]; then
    download_video "$share_url"
elif [[ $share_url == *"instagram.com"* ]]; then
    download_video "$share_url"
else
    echo "Unsupported URL. Only YouTube and Instagram URLs are supported."
    exit 1
fi
