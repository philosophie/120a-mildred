#= require jquery
#= require modernizr-custom
#= require_self

$ ->
  if Modernizr.touch
    $("body").addClass("touch")
  else
    $("body").addClass("no-touch")

    $slideshow = $(".js-fullscreen-slideshow")
    $parallaxEls = $slideshow.add(".js-fullscreen-lead-in")
    $header = $(".js-fullscreen-header")

    headerHeight = 0
    windowHeight = 0
    fullscreenHeight = 0
    headerOffset = 0

    initialize = (event) ->
      headerHeight = $(".js-fullscreen-header").outerHeight(true)
      windowHeight = $(window).height()
      fullscreenHeight = windowHeight - headerHeight
      headerOffset = fullscreenHeight * 2

      $(".js-fullscreen").height fullscreenHeight*2 + headerHeight

      $parallaxEls.height(fullscreenHeight)

      $(window).trigger "scroll" if event?

    initialize()

    $(window).resize initialize

    $parallaxEls.css
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

initializeMap = ->
  philosophieLatLng = new google.maps.LatLng(33.9865444, -118.4706925)

  map = new google.maps.Map(document.getElementById("map-canvas"), {
    center: philosophieLatLng
    zoom: 18
    mapTypeId: google.maps.MapTypeId.ROADMAP
    scrollwheel: false
    zoomControl: false
    mapTypeControl: false
    panControl: false
    streetViewControl: false
    styles: [
      {
        "featureType": "road.local",
        "stylers": [
          { "visibility": "simplified" }
        ]
      },{
        "featureType": "poi.attraction",
        "stylers": [
          { "visibility": "off" }
        ]
      },{
        "featureType": "poi.school",
        "stylers": [
          { "visibility": "simplified" }
        ]
      },{
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
          { "gamma": 0.57 }
        ]
      },{
        "featureType": "road.local",
        "elementType": "labels",
        "stylers": [
          { "visibility": "off" }
        ]
      },{
        "featureType": "poi.government",
        "stylers": [
          { "visibility": "off" }
        ]
      },{
        "featureType": "landscape.man_made",
        "stylers": [
          { "visibility": "off" }
        ]
      },{
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          { "visibility": "simplified" }
        ]
      },{
        "featureType": "administrative.land_parcel",
        "stylers": [
          { "visibility": "simplified" }
        ]
      },{
      }
    ]
  })

  marker = new google.maps.Marker
    position: philosophieLatLng,
    title: "120 Mildred"

  marker.setMap(map)

google.maps.event.addDomListener(window, "load", initializeMap)