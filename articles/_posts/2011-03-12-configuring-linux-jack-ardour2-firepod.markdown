---
layout: post
title: Configuring Linux, JACK and Ardour2 to work with the Presonus FirePOD
---

This article will help you install and configure your low-latency Linux DAW *(digital audio workstation)* using the
**Presonus Firepod** firewire recording system. 

I bought the Firepod a few years ago knowing it would work in Linux.  The first time around, configuring it was
a headache, but thankfully it has got progressively easier and more stable.

I had to replace some failing hardware and figured it was a good time to upgrade the OS and take notes. 

Please, please, PLEASE! Do me a favor and make backups of your data.  Better yet, do what I do, have a separate 
dedicated recording PC.  Your mileage may very.  No guarantees.  I suggest seeking out help from somebody you trust if you are 
not sure about any of these steps. 

### Install Ubuntu 10.04 LTS

These instructions assume that you have a fresh install of Ubuntu 10.04.  Even though 10.10 is out at the time 
of writing this, the Linux realtime kernel packages haven't been released yet.
  
### Install the Linux Realtime Kernel

The realtime kernel allows for the lowest latency possibly when recording.  This is needed if you plan on doing any 
overdubs.  Unless if you're recording everything at once, you will be doing overdubs.

Installation is easy, there is a package.

{% highlight text %}
  sudo apt-get install linux-rt  
{% endhighlight %}

Let it download and install the new kernel.

### Add your user to the 'audio' group

There are many ways you can do this.  I did:

{% highlight text %}
  sudo vim /etc/group
{% endhighlight %}

Find the 'audio' group and appended my username so it looks something like this

{% highlight text %}
  audio:x:29:pulse,username 
{% endhighlight %}

Of course, replace *username* with your actual system username.

### Install JACK sound server

Ardour uses the JACK sound server to communicate with the recording device.  
JACK is a beast in itself.  I'm just now starting to get comfortable with it.

{% highlight text %}
  sudo apt-get install jackd
{% endhighlight %}

### Update udev rules for the firewire 

This ensures that the firewire device is created under the 'audio' group during boot. 

Create or update /etc/udev/rules.d/40-persistant.rules with the following:

{% highlight text %}
  KERNEL=="raw1394", GROUP="audio" 
{% endhighlight %}

### Configure grub to give the kernel boot option

I like to be given the choice of which kernel to boot into during startup.  
Using your preferred editor, in my case *vim*, update the grub configuration file.

{% highlight text %}
  sudo vim /etc/default/grub 
{% endhighlight %}

Change the value of **GRUB_TIMEOUT** to **-1** and leave the rest of the file alone.

{% highlight text %}
  GRUB_TIMEOUT=-1
{% endhighlight %}

Save the file.  

Now you need to tell grub to update it's internal configuration.  Open a terminal and run:

{% highlight text %}
  sudo update-grub 
{% endhighlight %}

### Reboot

Reboot the machine.

When the system is booting up, grub should give the option of which kernel to boot into.  Choose
the kernel with the *-rt* suffix.

### Test the recording interface

Turn the FirePOD on.

The raw device should be mounted on the system with the group 'audio'.  Run a 'ls'
on the firewire device to check.  The output should look like this. 

{% highlight text %}
  ls -la /dev/raw1394
  crw-rw---- 1 root audio 171, 0 2011-03-12 15:25 /dev/raw1394
{% endhighlight %}

At this point, JACK should be able to connect to the FirePOD. 

qjackctl is the GUI JACK configuration helper.  It should be installed under: *Applications* > *Sound & Video* > *JACK Control*.

I'm not going to go into configuring JACK here.  I don't feel like I could adequately explain 
all the settings.  For now, here is a screen shot of my configuration.

![Alt JACK Control](/images/blog/qjackctl-ss.png)

You can now hit "Start" on *JACK Control's* main screen.  

The light on the FirePOD should turn from red to a blue.  This means that JACK has successfully connected to the FirePOD.

### Prepare to build Ardour 

Ardour has a lot dependencies.  Luckily, apt-get gives us a easy way fulfill all
them without installing that actual package.

{% highlight text %}
  sudo apt-get build-dep ardour
{% endhighlight %}

### Get Ardour

I always recommend building the newest stable version of Ardour to get the latest and greatest
tools and features.

Download ardour at: [http://www.ardour.org](http://www.ardour.org)

Once downloaded, find out what directory it downloaded to and unpack the .tar.bz2 file:

{% highlight text %}
  bunzip2 ardour-2.8.11.tar.bz2
  tar -xvf ardour-2.8.11.tar 
{% endhighlight %}

### Build and install Ardour

Ardour uses the scons build tool.  

Switch into the ardour source directory.

{% highlight text %}
  cd ardour-2.8.11
{% endhighlight %}

Run scons.

{% highlight text %}
  scons
{% endhighlight %}

This checks dependencies and compiles Ardour.  This takes awhile, even on my newer machine.

You can now install Ardour:

{% highlight text %}
  sudo scons install
{% endhighlight %}

### Run Ardour

Make sure that JACK is running and the FirePOD is connected, then you can start Ardour 
in the terminal.

{% highlight text %}
 ardour2
{% endhighlight %}

Thats it!  You can of course make a shortcut.  

I hope this article was helpful.  I'm considering this a work in progress and will update with
changes and corrections.  Please feel free to comment with tips and tricks that might streamline
this even more.

