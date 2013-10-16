#= require jquery
#= require_self

$ ->
  $slideshow = $(".js-fullscreen-slideshow")
  $parallaxEls = $slideshow.add(".js-fullscreen-lead-in")
  $header = $(".js-fullscreen-header")

  headerHeight = $(".js-fullscreen-header").outerHeight(true)

  windowHeight = $(window).height()
  fullscreenHeight = windowHeight - headerHeight
  headerOffset = fullscreenHeight * 2

  $(".js-fullscreen").height fullscreenHeight*2 + headerHeight

  $parallaxEls.height(fullscreenHeight).css
    position: "fixed"
    top: 0
    left: 0
    width: "100%"

  $(".js-fullscreen-lead-in").css "zIndex", 99
  $slideshow.css "zIndex", 100

  $header.css
    position: "fixed"
    bottom: 0
    left: 0
    width: "100%"

  parallax = true
  firstRun = true

  positionSlideshow = (offset) ->
    positionPercentage = (offset / fullscreenHeight) * 75
    $slideshow[0].style.webkitClipPath = "circle(50%, 50%, #{positionPercentage}%)"

  headerFixedToTop = false

  $(window).scroll (event) =>
    offset = $(window).scrollTop()
    return if offset < 0

    if offset > fullscreenHeight
      if offset >= headerOffset
        # fix header
        unless headerFixedToTop
          $header.css
            position: "fixed"
            top: 0
            bottom: "auto"

          headerFixedToTop = true
      else
        if headerFixedToTop
          $header.css
            position: "absolute"
            top: headerOffset
            bottom: "auto"

          headerFixedToTop = false

      return unless parallax

      if firstRun
        positionSlideshow(offset)
        firstRun = false

      parallax = false

      $parallaxEls.css
        position: "absolute"
        top: fullscreenHeight

      unless headerFixedToTop
        $header.css
          position: "absolute"
          top: headerOffset
    else
      unless parallax
        parallax = true

        $parallaxEls.css
          position: "fixed"
          top: 0

        $header.css
          position: "fixed"
          bottom: 0
          top: "auto"

    return unless parallax
    positionSlideshow(offset)
