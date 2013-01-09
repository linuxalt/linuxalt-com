---
layout: post
title: Subsonic not binding to IPv4 port in Ubuntu
---

I've recently started using **Subsonic** as my music player.  With it, I have streaming
access to all my music via a browser or an *Android* application.  It's great, I love it!

About a week ago I updated Java on my system and it broke my **Subsonic** install.  It
would work locally but not remotely.

After some troubleshooting, I noticed that it was binding to the IPv6 port but not IPv4.

I dug around Google and finally found [this](http://www.activeobjects.no/subsonic/forum/viewtopic.php?p=9847). 

Apparently, Java 1.6 favours IPv6 by default and will not use IPv4 unless you explicitly tell it to.

The fix is to edit your */usr/share/subsonic/subsonic.sh* file and add the follow argument to the Java
call to start **Subsonic**.

{% highlight text %}
  -Djava.net.preferIPv4Stack=true
{% endhighlight %}

The Java call should look something like this:

{% highlight text %}
${JAVA} -Xmx${SUBSONIC_MAX_MEMORY}m \
  -Dsubsonic.home=${SUBSONIC_HOME} \
  -Dsubsonic.host=${SUBSONIC_HOST} \
  -Dsubsonic.port=${SUBSONIC_PORT} \
  -Dsubsonic.httpsPort=${SUBSONIC_HTTPS_PORT} \
  -Dsubsonic.contextPath=${SUBSONIC_CONTEXT_PATH} \
  -Dsubsonic.defaultMusicFolder=${SUBSONIC_DEFAULT_MUSIC_FOLDER} \
  -Dsubsonic.defaultPodcastFolder=${SUBSONIC_DEFAULT_PODCAST_FOLDER} \
  -Dsubsonic.defaultPlaylistFolder=${SUBSONIC_DEFAULT_PLAYLIST_FOLDER} \
  -Djava.awt.headless=true \
  -Djava.net.preferIPv4Stack=true \
  -jar subsonic-booter-jar-with-dependencies.jar > ${LOG} 2>&1 &
{% endhighlight %}

I'm sure this will be fixed in future versions.  Hopefully this will help somebody else out.
