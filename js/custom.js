// Offset for Site Navigation
$('#siteNav').affix({
	offset: {
		top: 100
	}
})

//To allow smooth scrolling for in-page jumps
$('a[href^="#"]').on('click', function(event) {

    var target = $(this.getAttribute('href'));

    if( target.length ) {
        event.preventDefault();
        $('html, body').stop().animate({
            scrollTop: target.offset().top
        }, 1000);
    }

});