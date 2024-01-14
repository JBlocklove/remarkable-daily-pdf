# remarkable-daily-pdf

This project allows you to automatically download daily PDFs directly on your Remarkable Tablet. No syncing with the cloud or a computer required!

---
## Currently only compatible with versions up to 2.15
3.* is partially supported in the `dev` branch, but we can only use the built-in `wget` which lacks TLS support.

### Requirements
This is designed to work with an unmodified Remarkable setup. You should know how to `ssh` into your Remarkable, but otherwise nothing should need to be installed.

If the documents you wish to download require a subscription, you should have an active subscription. This is not a method to pirate anything.

### Setup
The following uses the New York Times crossword as an example. Instructions should be similar for any other sites.
#### Step 1
  You can clone this repo and copy the files to your Remarkable by using `scp` or something similar

  You can also run the install script automatically by running this command on your remarkable
  ```
  sh -c "$(wget https://raw.githubusercontent.com/JBlocklove/remarkable-daily-pdf/main/install.sh -O-)"
  ```
  This will place these files in a directory called `remarkable-daily-pdf` and ask if you want to setup automatic downloads as described below.

#### Step 2
  Follow the prompts given by the install script to setup your daily downloads. URL and name are required, but you can leave the cookie file location and directory blank. This will create a `download-pdfs` script that the `systemd` service will use to download your media every day.

### Running Manually
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

### Setting Up Automatic Downloads
If you want this script to run every day and you want to set it up or modify it manually, you can copy the `download_pdf.service` and `download_pdf.timer` files to `/etc/systemd/system/` on your remarkable and then run `systemctl enable download_pdf.timer`. This should sync the crossword once per day once the remarkable has woken up and connected to the internet.

From there, make an executable file called `download-pdfs` in your `remarkable-daily-pdf` directory which calls the `rm-sync-pdf` command for you. An example of this file is provided in this repo.

If you use the install script above, it can handle this for you.

---

### To Do
 - [x] Make scripts more generic so that a range of different sources can be used
    - [ ] Create a list of supported sources for easier use, especially focusing on free ones
 - [ ] Figure out the NYT pdf naming structure for the non-newspaper print versions so you can get the puzzle without the previous day's answers
 - [ ] Improve this documentation

---
### Contributions
Any ideas are welcome and greatly appreciated! Shell scripting isn't my main thing so I'm sure there are a lot of potential improvements to this. If any problems or questions arise, please feel free to make an issue and I'll do my best to help resolve it!
