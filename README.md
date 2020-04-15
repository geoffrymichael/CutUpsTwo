# CutUpsTwo


Version 2.1

Added support to fetch a random line of text from a random book from Project Gutenberg.


March 28 2020

Version 2.0 Deployed to the App Store. This version includes Core ML/Core Vision functionality to be able to scan physical text sources and convert them into digital text as an additional source. 


March 22, 2020 Version 1.2.0

Added support for Dark Mode


Version 1.0 was accepted and is on the apps store.

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


