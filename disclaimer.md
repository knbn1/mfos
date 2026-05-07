Hi.

MicroflashOS is meant to supplement the lore which is hosted on [GitHub Pages](https://knbn1.github.io/sitefiles/microflash/mfos-lore.txt). As a result, it should not be taken as seriously as an effort to build a full-fledged operating system with a kernel, bootloader, packages, etc. from scratch like Haiku or Kolibri. If you are looking for that kind of stuff, please look elsewhere, as you likely won't find what you are looking for here. I do not wish to deal with inquiries about flashing this abomination onto a USB drive.

At the same time however, I've tried my best to make it feel like an actual operating system on the market, simply because I want you, the end user, to have a good time using it.

I know the code may be... bad at times but I'm working on improving my skills! Repetition, unoptimized code, it's all part of the process of learning!

That said, feel free to reach out (contact info is on [my website](https://knbn1.github.io)) if you think I could improve something. Or if you just wanna share some words of encouragement. If you want to analyse/break down my code, feel free to! It isn't obfuscated in the slightest, quite the opposite actually as I commented the code to oblivion.

-knb

Some questions and answers to them:

- *Will you port this to X language?* I do not plan on porting this anywhere at all in the future, but you are welcome to try.
- *Why didn't you make it out of X language?* Sadly Batch is the only language I'm familiar with, and only to an extent. As I'm struggling with my studies I can't invest the time to learn a new language, and I'm happy with how my little project is going in Batch.
- *Does the ```mfos``` folder matter?* No. The only thing in your file system that actually has a purpose to MicroflashOS is the userdata folder, as it can change depending on what you do with it, which MicroflashOS adapts to. For example, toggles are written there, which MicroflashOS checks for to apply settings. If you were to remove all checks for the system partition (```disk0p1```) MicroflashOS would still work, as the partition functions only as a "prop" to enhance the immersion. However I don't intend on removing it anytime soon as it adds a layer of "fun" accessible via ```mountsys``` :)
