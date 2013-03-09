Screentweetr is an AIR application for uploading desktop screenshots to twitter image services. You can download it now, from the [AIR Marketplace][1].

[![Screentweetr][3]][3]

### So, what is Screentweetr?

Screentweetr is an application built on AIR (Adobe Integrated Runtime). It uses the [TwitPic][3] / [TweetPhoto][4] / [ScreenTweet][5] / [Twitgoo][6] / [yFrog][7] / [MobyPicture][8] / [img.ly][9] / [Posterous][10] / [TwitrPix][11] / [TwitDoc][12] service(s) – which links in to your twitter account – and takes image data from your clipboard and allows you to quickly upload it directly to TwitPic / TweetPhoto / ScreenTweet / Twitgoo / yFrog / MobyPicture / img.ly / Posterous / TwitrPix / TwitDoc, and the option to immediately tweet the same image on [Twitter][13].

### How does it work?

You might have seen my previous post: [“Print Screen detection in AIR”][14] – that’s the core functionality. Using the classes discussed in that post, the application listens for bitmap data on the clipboard. Add in the JPEG encoder classes of the AIR framework to turn raw bitmaps into JPEG files, and then use the TwitPic API to post the JPEG data along with twitter credentials.

What the user sees, initially, is not much (apart from the welcome screen). When you take a screenshot however, a chirpy little notification window appears and offers you a way to upload your screenshot.

![Screentweetr][15]

The advantage really is in the process – no longer is it a case of “Print screen”, [paste into image software, save,] open website, select file, upload, tag, post – it’s now a case of “Print screen”, tag, upload. You don’t even end up creating an actual file on your computer – it’s all virtual. (Which maybe isn’t all good, but hey).

### Why did I build it?

Well first of all, it doesn’t look like anyones’ made a similar application. In addition, the concept is really quite simple. The core functionality took only a couple of days to put together from scratch. (I’ve spent a lot more time in total on the development but hey, that’s the fun of learning all the time.)

Building successful little applications relies on the application being a) good at what it does and b) focussed on its task. Well, that’s what I think. Big companies with established multiple-task products have got there with many years and many developers – if you don’t have that then you need to start small and focus on what you want the application do to, and do it well.

For example; [ImageSizer][16] takes images and resizes them. That’s its core function, and that’s all its gonna do. I know I haven’t a hope of competing with professional software and all it’s features, so I’m not trying to compete. If I’m going to make an application that can add snazzy pixel bender effects to images, then it’s going to be a separate application – and that’s what Screentweetr is all about. It’s taking a potential user scenario – the process of screenshot to twitter – and building an application to facilitate that.

### What’s in store for the future?

Oh my, where do we start? Well, there’s three key elements to the future development; Visuals, Services and User experience. Visuals and user experience are just generally improving the look and feel of the application, and how it works. Services were suggested by [@destroytoday][17] and sounds like a good idea – basically adding support for more than one image uploading service. So, [TweetPhoto][4] is on the list to go alongside support for TwitPic. TweetPhoto, ScreenTweet and TwitPic are all supported, and there’s plans for more… 10 services are now supported – check the top of the page for the complete list.

### Where can I download it?

That’s simple. Screentweetr is available for [download from the Adobe AIR Marketplace][18]. I’ll get an install badge up on here soon, but for now, just go to the AIR Marketplace.

 [1]: http://www.adobe.com/cfusion/marketplace/index.cfm?event=marketplace.offering&marketplaceid=1&publisherid=10603&offeringid=13500
 []: http://www.adobe.com/cfusion/marketplace/index.cfm?event=marketplace.offering&marketplaceid=1&publisherid=10603&offeringid=13500
 [3]: http://twitpic.com/
 [4]: http://www.tweetphoto.com/index.php
 [5]: http://screentweet.com/
 [6]: http://twitgoo.com/
 [7]: http://yfrog.com/
 [8]: http://www.mobypicture.com/
 [9]: http://img.ly/
 [10]: http://posterous.com/
 [11]: http://twitrpix.com/
 [12]: http://twitdoc.com/
 [13]: http://twitter.com/home
 [14]: http://www.psyked.co.uk/general-chit-chat/print-screen-detection-in-air.htm
 [15]: http://uploads.psyked.co.uk/2009/06/screentweetr2.jpg "Screentweetr"
 [16]: http://www.psyked.co.uk/adobe/apollo/imagesizer-version-049-released.htm
 [17]: http://twitter.com/destroytoday
 [18]: http://www.adobe.com/cfusion/marketplace/index.cfm?event=marketplace.offering&marketplaceid=1&publisherid=10603&offeringid=13500 "Click here to visit the AIR Marketplace to download Screentweetr." 
