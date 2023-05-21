# down
down is an Instagram/YouTube Video Downloader for Termux
## Prerequisites
- Termux
- Python 3.7 or higher with pip
- yt-dlp
- exiftool
- ffmpeg
- termux-tools
## Installation
### Install Dependencies
```bash
apt update && apt full-upgrade -y && apt install -y python ffmpeg exiftool termux-tools && pip install -U pip && pip install yt-dlp
```
### Install down
```bash
curl -sSL https://raw.githubusercontent.com/Arkapravo-Ghosh/down/main/install.sh | bash
```
## Usage
```bash
down -h
```
> NOTE: You can simply run `down` to download a video from Instagram or YouTube. It'll automatically prompt you to enter the URL of the video you want to download.
