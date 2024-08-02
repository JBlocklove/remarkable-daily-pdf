# remarkable-daily-pdf

This project allows you to automatically download daily PDFs directly on your Remarkable Tablet. No syncing with the cloud or a computer required!

---

## Requirements
This is designed to work with a standard remarkable setup. You should know how to `ssh` into your Remarkable, but otherwise nothing should need to be installed that isn't handled by the installation script.

If the documents you wish to download require a subscription, you should have an active subscription. This is not a method to pirate anything.

## Setup

#### Step 0 - Cookies (Optional)
If the pdfs you want to download require a subscription (such as the NYT Crossword), you'll need to download the cookies first. This can be done with various browser extensions like [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/) for Firefox. Save the cookies for the relevant site and put them on your remarkable in a known location. I created a directory `~/cookies` in my case, so that will be pointed to in the following instructions.

### Automagic (Recommended)

#### Step 1

Run the install script on your remarkable using the following command:
  ```
  sh -c "$(wget https://raw.githubusercontent.com/JBlocklove/remarkable-daily-pdf/main/install.sh -O-)"
  ```
  This will download the repo and place these files in a directory called `~/.local/share/daily-pdf` and prompt for setting up a pdf download

#### Step 2
Following the prompts, it will ask `Do you want to set up a pdf download now?`.

If you hit `enter` or `n` the script will exit and you will need to manually set up downloads later.

Entering `y` will lead to the following prompts. The New York Times crossword will be used as an example.

- **URL:**
```
What URL would you like to pull from every day?
```
If the URL changes every day, based on the date for example, that can be implemented in the URL using backticks and another command.For example, the URL for the NYT crossword is:
```
https://www.nytimes.com/svc/crosswords/v2/puzzle/print/`date +%b%d%y`.pdf
```
The embedded `date` command changes the date to the required format for each day.

- **Document Name:**
```
What name would you like to give the downloaded documents?
```
This should be set to something that changes every day, once again using something like the `date` command.

*NOTE: Currently the scripts for adding files will ignore the file move if that file already exists. In the future there can be options for overwriting or duplicating files, if requested. If this is something you need, please open an issue.*

```
`date +'%d - %a'`
```
This `date` command will resolve to the day of the month followed by day of the week. For example `02 - Fri`

- **Location (Optional):**
```
What directory would you like it to be in? Leave blank if you want it to save at the top level.
```

This is the folder path you'd like to download pdfs to.
```
/Crosswords/`date +'%Y'`/`date +'%m - %b'`
```

This makes a `Crosswords` folder in the top-level, followed by a year folder, followed by a numbered month folder. For example `/Crosswords/2024/08 - Aug`

- **Cookies (Optional):**
*If your download requires cookies, follow Step 0 first*
```
If this needs a cookie file, what is the file's location? Leave blank if it is not needed.
```

This should just point to the necessary cookie file if your download requires authentication. You should use absolute paths for the automatic download.

```
/home/root/cookies/nyt-cookies.txt
```

#### Step 3
The script will prompt if you want to run this automatically every day. If yes, it will make a `systemd` timer to pull the pdf every day starting at midnight.

**This process is dependant on internet connection, so the file will not actually download until you connect your tablet to wifi for the first time each day. It can take a minute for the document to download and move, so be aware that your remarkable will refresh shortly after starting it up each day.**

#### Step 4
The script will prompt if you want to start an initial download now, so you don't need to wait until the next midnight to make sure it works.

#### Step 5
Enjoy your automatically downloading files!

### Manual
You can clone this repo and copy the files to your Remarkable by using `scp` or something similar. Remember to clone it with the `--recursive` flag, as this uses a submodule,

#### Running the download script manually
```
Usage: rm-sync-pdf [OPTIONS]
        Mandatory Options:
                -u:      URL to pull pdf from.
                -n:     Name to give the downloaded pdf.
        Optional Options:
                -c:     Location of a cookie file. Necessary if authentication is required for the pdf.
                -d:     Directory on the remarkable to store the file under.
                        If any of the directories in the path don't exist they will be created.
                -h      Prints this usage message and exits.
```

#### Setting up automatic downloads
If you want this script to run every day and you want to set it up or modify it manually, you can copy the `download_pdf.service` and `download_pdf.timer` files to `/etc/systemd/system/` on your remarkable and then run `systemctl enable download_pdf.timer`. This should sync the crossword once per day once the remarkable has woken up and connected to the internet.

From there, make an executable file called `download-pdfs` in your installed `remarkable-daily-pdf` directory which calls the `rm-sync-pdf` command for you. You may need to change the location of this script in the `download-pdfs.service` file. An example of this file is provided in this repo.

---

### To Do
 - [ ] Create a list of supported sources for easier use, especially focusing on free ones
 - [ ] Figure out the NYT pdf naming structure for the non-newspaper print versions so you can get the puzzle without the previous day's answers
 - [ ] Improve this documentation

---
### Contributions
Any ideas are welcome and greatly appreciated! Shell scripting isn't my main thing so I'm sure there are a lot of potential improvements to this. If any problems or questions arise, please feel free to make an issue and I'll do my best to help resolve it!
