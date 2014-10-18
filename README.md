fedora_course_scraper
=====================

Scape the videos from a school's site backed by usefedora.com.  This will download all video lessons for offline learning.


##Compatibility:

This has only been tested on Mac OSX 10.9, though other systems will
probably work as well.

##Dependencies:

- homebrew
- npm
- phantomjs
- casperjs

If npm is not yet installed, use homebrew (brew.sh), a package manager
for the Mac.

```bash
$ brew install npm
```

To install phantomjs, use homebrew:

```bash
$ brew install phantomjs
```

To install casperjs, use npm (to get the latest beta version not yet
    available on homebrew).

```bash
$ npm install -g casperjs
```

## Configuration

You must modify the variables contained at the top of the course_scraper.coffee file:

| CONFIGURATION_KEY | USE                                                                              |
| :---------------- | :--                                                                              |
| FEDORA_SCHOOL_URL | Entry point of the script and URL of the school whose course(s) you are scraping |
| COURSE_TITLE      | Full name of the course you'd like to scrape                                     |
| EMAIL             | Your email address                                                               |
| PASSWORD          | Your password                                                                    |
| DOWNLOAD_DIR      | Absolute path to folder that will contain downloaded files                       |

## Usage

Downloading requires tweaking some default casperjs command line options:
Use without these flags will cause the downloads to fail!

```bash
casperjs course_scraper.coffee --ssl-protocol=any --ignore-ssl-errors=true --cookies-file=cookies.txt
```

The script will only download files that are not present.  Should a file fail to download (0 bytes), delete it and re-run the script.  This may be improved later to automatically scan the directly upon completion and re-download files that were unsuccessful.  But for now, this is a manual process.

## License and Liability
Use of this script to facilitate the violation of copyright law or for other illegal purposes is strictly forbidden, and you will not hold me liable if you use this script to those ends.

The source code is released under the terms of the MIT License, which is available for your perusal in this repository.

Copyright Curtis Ekstrom, 2014.
