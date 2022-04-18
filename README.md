# remarkable-daily-pdf

This project allows you to download a daily PDF directly on your Remarkable Tablet. No syncing with the cloud or a computer required!

Currently only set up for the New York Times Crossword, but should be easily modifiable to grab pretty much any daily documents.

---

### Requirements
This is designed to work with an unmodified Remarkable setup. You should know how to `ssh` into your Remarkable, but otherwise nothing should need to be installed.

If the documents you wish to download require a subscription, you should have an active subscription. This is not a method to pirate anything.

### Setup
The following uses the New York Times crossword as an example. Instructions should be similar for any other sites, though will require some modification of the scripts at the moment.
#### Step 1
  You can clone this repo and copy the files to your Remarkable by using `scp` or something similar

  You can also run the install script automatically by running this command on your remarkable
  ```
  sh -c "$(wget https://raw.githubusercontent.com/JBlocklove/remarkable-daily-pdf/main/install.sh -O-)"
  ```
  This will place these files in a directory called `remarkable-daily-pdf-main` and ask if you want to setup automatic downloads as described below.

#### Step 2
  Create an `nyt-cookies.txt` file by opening a console in your browser (usually by hitting F12) and running the command `document.cookie` on the New York Times crossword page while logged in. Copy the output of that to a text file called `nyt-cookies.txt` and place that in the `remarkable-daily-pdf-main` directory.

### Running
Run `rm-sync-nyt` and you should be good to go!

### Setting Up Automatic Downloads
If you want this script to run every day, you can copy the `crossword.service` and `crossword.timer` files to `/etc/systemd/system/` on your remarkable and then run `systemctl enable crossword.timer`. This should sync the crossword once per day once the remarkable has woken up and connected to the internet.

If you use the install script above, it can handle this for you.

---

### To Do
 - [ ] Make scripts more generic so that a range of different sources can be used
    - [ ] Create a list of supported sources for easier use, especially focusing on free ones
 - [ ] Figure out the NYT pdf naming structure for the non-newspaper print versions so you can get the puzzle without the previous day's answers
 - [ ] Improve this documentation

---
### Contributions
Any ideas are welcome and greatly appreciated! Shell scripting isn't my main thing so I'm sure there are a lot of potential improvements to this. If any problems or questions arise, please feel free to make an issue and I'll do my best to help resolve it!
