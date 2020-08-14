# CutUpsTwo

Version 3.0
08/14/2020

Fold-in functionality added. 

A fold-in can be thought of as almost a completely different cut-up technique. In the original literary sense, the idea was soldified by William S. Burroughs. The concept is that you would take a single page from, perhaps, an eary section of a novel or book. You would rip this page out, fold it in half down across the vertical axis and place it down with the first half of the page showing. Then you would take a page from a later part of the book and do the same folding down the middle, but instead have the second half of that page showing. Then you would place the first folded page next to the second folded page to create a new single page and attempt to read across the lines and see if any interesting combinations or joinings occured. Notice here that with physical media, there is somewhat of a restriction that the two pages being folded together must be simlar in font size/formatting to work. 

I find it interesting using this method with digital media sources. If you try to take something like copied text from the kindle app, let's say, there really are no carraige returns, the text just wraps around of course. However, in kind of a funny juxtaposition of coming back to the original concept, if you take a screenshot of two different pages to fold-in (and you can essentially delineate/customize your page size using font size) it is really easy to have uniform formatted pages of text across different sources. The original real world concept specified you wanted each of your pages to come from at least similarly formatted sources, because otherwise, obviously, the text would not line up. The digital reproduction of books and text essentially eliminates a lot of this restriction. 

For this app, replication of the technique is done using a simple Swift extension on an array that returns a tupple of both the first half and second half of an array. These respective parts are then joined back together alternating between first half of first line, first page, and second half of first line, second page, and so on.  

Version 2.6
08/02/2020

Added different cut-up algorithms-- currently the options are to split text by individual lines(carraige-returns) which was the original base functionality of the 1.0 app, by single words, by every third word, and by every fifth word.

Cut-ups in real life would commonly be split into different sizes as opposed to single lines of text. This allowed for more variation in possible combinations that might be produced, ranging from, essentially, more random (single words) which might essentially just produce jibberish, to less random (individual lines) that might be kind of boring and uninspiring even when rearranged-- it really all depends on the source material. But now there is more customization ability to adapt to different source materials.  

For the app, duplication of the real world process is achieved with a Swift extension on an array that allows an array to be split into specified chunk sizes. 


Version 2.4
06/15/2020

Implemented the ability to scan and recognize text from still images from iOS photo library. 

Updated algorithm to provide more and better text data for random feature.


Version 2.1
05/01/2020

Added support to fetch a random line of text from a random book from Project Gutenberg.

This is achieved by an algorithm that takes a random number (in this case, from around 100 - 60,000) which is roughly the size of the gutenberg database of books and then takes a random section (dependent on the word count of whatever book is retrieved) and spits out that random section. It can be very random, but sometimes does produce some interesting little snippets that should be helpful for inspiration from time to time. 

Version 2.0 
03/28/2020

This version includes Core ML/Core Vision functionality to be able to scan physical text sources and convert them into digital text as an additional source. 


Version 1.2.0 
03/22/2020

Added support for Dark Mode


Version 1.0
03/21/2020

App accepted and released on the App Store


Status: March 20, 2020

I am trying to prepare for a 1.0 launch.

Most of the early and basic functions are working and CRUD is implemented. Plans for future releases are to include persistence via Core Data and also to implement Core Vision ML to be able to scan physical texts in as sources. 


The Cut-up technique is a creativity process originally popularized by the DADAists. It involves cutting up existing text sources and rearranging them to inspire new ideas. The method was later used by William S. Burroughs, David Bowie, and Radiohead among others. 
    
    Instructions:

    •) Paste in any copied text such as a poem, lyrics, a journal or diary entry-- even *news articles(although these may require more care in formatting into separate lines). Paste in any text you want
    
    •) Any text that is separated by a "return" will be counted as a new line

    •) You can use the "return" on the iOS keyboard to simulate cutting the text anywhere you want. Many source materials may already automatically have lines separated when you paste them in, but it could be fun to cut up lines even further, perhaps in-half. 

    •) Feel free to type in extra lines on the fly or edit existing lines using the keyboard
    
    •) Copying and pasting from different sources is a good way to get interesting blends
        
    •) When you are satisfied with your formatting, clicking on "Automatic" will cut the text into lines and send them to the editing board

    •) You can also use iOS' built-in copy and paste to manually send a single line, words, or word to the editing board.

    •) To begin rearranging the lines, click on the "Edit" button
    
    •) Rearranging can be done manually by clicking on a line and dragging it, or automatically by clicking "shuffle". You can press shuffle as many times as you wish
    
    •) You can go back to the input screen and add more content at any time
    
    •) Export your rearranged lines via the "Share" button.

    •) Press "Clear" to start over completely

    * REMEMBER TO ABIDE BY ANY LICENSING AND ATTRIBUTION REQUIREMENTS IF YOU USE THIRD PARTY SOURCES
    """


Early early prototype of solo project to emulate https://en.wikipedia.org/wiki/Cut-up_technique and https://www.youtube.com/watch?v=m1InCrzGIPU

Status: January 20, 2020 (on break to study for FAANG coding interview)

The end goal is a creativity helper app. In this case, it will, I hope, recreate the function of the so called cut-ups process of inspiration popularized originally by William S. Burroughs and then by David Bowie and Radiohead. The basic concept is to have a set of cohesive text (like a book page, a poem, a journal entry, etc) that one would physically cut up and rearrange to see what novel word associations might appear. Examples: https://en.wikipedia.org/wiki/Cut-up_technique and https://www.youtube.com/watch?v=m1InCrzGIPU. 


The current iteration is a very early draft. Currently I have hi-jacked my main root view button to link to a document text analyzer view just to mess around with the API which I have never used before. I hope to be able to use this as an additional data source in the future. I am using code from apples' sample project for the API currently. The button normally takes an amount of text in the text view and allows a user to cut dynamically using the placement of the iPhone cursor.  That text can then be rearranged tactically via a table view controller with drag and drop. 


