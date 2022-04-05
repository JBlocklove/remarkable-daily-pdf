# remarkable_nyt_crossword

The project allows you to download the New York Times crossword directly on your Remarkable Tablet. No syncing with the cloud or a computer required!

---

### Requirements
This is designed to work with an unmodified Remarkable setup. You should know how to `ssh` into your Remarkable, but otherwise nothing should need to be installed.

You will need a paid New York Times subscription for at least the crossword.

### Setup
#### Step 1
  You can clone this repo and copy the files to your Remarkable by using `scp` or something similar

  You can also pull it straight on to your Remarkable by `ssh`ing in and running the following:
  ```
  wget -qO- https://github.com/JBlocklove/remarkable_nyt_crossword/archive/main.zip | unzip -
  ```
  This will place these files in a directory called `remarkable_nyt_crossword-main`
  
#### Step 2
  Create an `nyt-cookies.txt` file by opening a console in your browser (usually by hitting F12) and running the command `document.cookie` on the New York Times crossword page while logged in. Copy the output of that to a text file called `nyt-cookies.txt` and place that in the `remarkable_nyt_crossword-main` directory.

#### Step 3
  Create a directory on your Remarkable called Crosswords. All of your crosswords will be stored here under an additional directory named by the month and year.
  
### Running
Run `rm_sync_nyt.sh` and you should be good to go!

---

### To Do
 - [ ] Create a systemd hook so that this will run automatically when connected to wifi
 - [ ] Make scripts more generic so that any files can be added without the need of the Remarkable cloud or their API
 - [ ] Improve this documentation
