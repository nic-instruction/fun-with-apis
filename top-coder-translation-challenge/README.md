# Translation Challenge (Google Translate API)

I was looking for a fun way to practice python and bash before an interview and decided to do some top coder challenges in both Bash and Python.  This challenge wants you to translate a short line of text into another language, by using the Google Translate API.

Pretty simple!  Make an http request with this:

```
{"sentences":[{"trans":"Hi","orig":"Hallo","backend":1}],"dict":[{"pos":"noun","terms":["halloo"],"entry":[{"word":"halloo","reverse_translation":["Hallo","Horrido","Halloruf"],"score":1.3212133E-5}],"base_form":"Hallo","pos_enum":1}],"src":"de","confidence":0.93561107,"spell":{},"ld_result":{"srclangs":["de"],"srclangs_confidences":[0.93561107],"extended_srclangs":["de"]}} 
```

I'll need to update it with another sentance, but I plan on using python with beautiful soup and bash with curl to take a sentance as input and get it translated.

(note: this is actually a more complex task than the challenge requires, but I also think it will be more fun!)
