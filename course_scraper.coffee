fs = require('fs')

#############  Configure to your heart's content ###########################

FEDORA_SCHOOL_URL = "http://bitfountain.io"
COURSE_TITLE      = "The Complete iOS 7 Course - Learn by Building 14 Apps"
EMAIL             = "your@email.com"
PASSWORD          = "p@$$word"
DOWNLOAD_DIR      = "/path/to/download/directory/#{COURSE_TITLE}"
DOWNLOADED_FILES  = fs.list(DOWNLOAD_DIR).slice(2)

############################################################################

casper = require('casper').create(
  waitTimeout: 1000
  pageSettings:
    userAgent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.10 (KHTML, like Gecko) Chrome/23.0.1262.0 Safari/537.10"
    loadImages: false
    webSecurityEnabled: no
    loadPlugins: false
  logLevel: "debug"
)

x = require('casper').selectXPath

lessonPages = []
lessonPageUrl = ''
videoLlink = ''
videoTitle = ''
videoIndex = 0
index = ''

casper.start FEDORA_SCHOOL_URL, ->
  @echo "Visiting site"

casper.then ->
  casper.waitForText('Login', ->
    casper.click(x('//*[text()="Login"]'))
  )

casper.then ->
  @echo "Logging in..."
  @fill('form#target', { email: EMAIL, pw: PASSWORD }, true)

casper.then ->
  @echo "Accessing course #{COURSE_TITLE}"
  casper.click(x("//*[text()='#{COURSE_TITLE}']"))

casper.then ->
  fs.makeDirectory DOWNLOAD_DIR unless fs.exists(DOWNLOAD_DIR)

casper.then ->
  @echo "Finding lessons..."
  lessonPages = @evaluate ->
    lessons = __utils__.findAll('tr.lecture_tr')
    Array.prototype.map.call(lessons, (lesson) ->
      return lesson.getAttribute('onclick').match(/(http\:\/\/[\w+./-]+)/)[0]
    )

casper.then ->
  casper.eachThen(lessonPages, (page) ->
    index = ("000" + (videoIndex += 1)).substr(-3,3)
    alreadyDownloaded = ->
      Array.prototype.some.call(DOWNLOADED_FILES, (file) ->
        return file.slice(0,3) == index
      )

    if alreadyDownloaded()
      @echo "Skipping video #{index}"
    else
      casper.thenOpen(page.data, ->
        videoLink = @evaluate ->
          return __utils__.findOne('div.well a').getAttribute('href')

        videoTitle = @evaluate ->
          return __utils__.findOne('#lecture_heading').textContent.slice(2)

        path = "#{DOWNLOAD_DIR}/#{index}_#{videoTitle}.mp4"

        @echo "Downloading to #{path}..."
        @download(videoLink, path)
      )
  )

casper.run ->
  @exit()
