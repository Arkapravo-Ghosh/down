#!/data/data/com.termux/files/usr/bin/bash
display_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo "Options:"
    echo "  -h, --help       Display this help message"
    echo "  -u, --url URL    Specify the share URL of the video"
    echo ""
    echo "down v1.0.5 Made by Arkapravo Ghosh"
}
download_video() {
    video_url="$1"
    if [[ $video_url == *"instagram.com"* ]]; then
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
    elif [[ $video_url == *"youtube.com"* ]] || [[ $video_url == *"youtu.be"* ]]; then
        yt-dlp --merge-output-format mp4 -f "bestvideo+bestaudio[ext=m4a]/best" "$1"
        download_dir="$HOME/storage/downloads"
        mv *.mp4 "$download_dir"
        am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d "file://$download_dir"
    else
        echo "Unsupported URL domain."
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
download_video "$share_url"
