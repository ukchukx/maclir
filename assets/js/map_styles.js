const styles = {
	shiftWorker: [
	    {
	        "stylers": [
	            {
	                "saturation": -100
	            },
	            {
	                "gamma": 1
	            }
	        ]
	    },
	    {
	        "elementType": "labels.text.stroke",
	        "stylers": [
	            {
	                "visibility": "off"
	            }
	        ]
	    },
	    {
	        "featureType": "poi.business",
	        "elementType": "labels.text",
	        "stylers": [
	            {
	                "visibility": "off"
	            }
	        ]
	    },
	    {
	        "featureType": "poi.business",
	        "elementType": "labels.icon",
	        "stylers": [
	            {
	                "visibility": "off"
	            }
	        ]
	    },
	    {
	        "featureType": "poi.place_of_worship",
	        "elementType": "labels.text",
	        "stylers": [
	            {
	                "visibility": "off"
	            }
	        ]
	    },
	    {
	        "featureType": "poi.place_of_worship",
	        "elementType": "labels.icon",
	        "stylers": [
	            {
	                "visibility": "off"
	            }
	        ]
	    },
	    {
	        "featureType": "road",
	        "elementType": "geometry",
	        "stylers": [
	            {
	                "visibility": "simplified"
	            }
	        ]
	    },
	    {
	        "featureType": "water",
	        "stylers": [
	            {
	                "visibility": "on"
	            },
	            {
	                "saturation": 50
	            },
	            {
	                "gamma": 0
	            },
	            {
	                "hue": "#50a5d1"
	            }
	        ]
	    },
	    {
	        "featureType": "administrative.neighborhood",
	        "elementType": "labels.text.fill",
	        "stylers": [
	            {
	                "color": "#333333"
	            }
	        ]
	    },
	    {
	        "featureType": "road.local",
	        "elementType": "labels.text",
	        "stylers": [
	            {
	                "weight": 0.5
	            },
	            {
	                "color": "#333333"
	            }
	        ]
	    },
	    {
	        "featureType": "transit.station",
	        "elementType": "labels.icon",
	        "stylers": [
	            {
	                "gamma": 1
	            },
	            {
	                "saturation": 50
	            }
	        ]
	    }
	],
	blueEssence: [
	    {
	        "featureType": "landscape.natural",
	        "elementType": "geometry.fill",
	        "stylers": [
	            {
	                "visibility": "on"
	            },
	            {
	                "color": "#e0efef"
	            }
	        ]
	    },
	    {
	        "featureType": "poi",
	        "elementType": "geometry.fill",
	        "stylers": [
	            {
	                "visibility": "on"
	            },
	            {
	                "hue": "#1900ff"
	            },
	            {
	                "color": "#c0e8e8"
	            }
	        ]
	    },
	    {
	        "featureType": "road",
	        "elementType": "geometry",
	        "stylers": [
	            {
	                "lightness": 100
	            },
	            {
	                "visibility": "simplified"
	            }
	        ]
	    },
	    {
	        "featureType": "road",
	        "elementType": "labels",
	        "stylers": [
	            {
	                "visibility": "off"
	            }
	        ]
	    },
	    {
	        "featureType": "transit.line",
	        "elementType": "geometry",
	        "stylers": [
	            {
	                "visibility": "on"
	            },
	            {
	                "lightness": 700
	            }
	        ]
	    },
	    {
	        "featureType": "water",
	        "elementType": "all",
	        "stylers": [
	            {
	                "color": "#7dcdcd"
	            }
	        ]
	    }
	],
	mutedBlue: [
	    {
	        "featureType": "all",
	        "stylers": [
	            {
	                "saturation": 0
	            },
	            {
	                "hue": "#e7ecf0"
	            }
	        ]
	    },
	    {
	        "featureType": "road",
	        "stylers": [
	            {
	                "saturation": -70
	            }
	        ]
	    },
	    {
	        "featureType": "transit",
	        "stylers": [
	            {
	                "visibility": "on"
	            }
	        ]
	    },
	    {
	        "featureType": "poi",
	        "stylers": [
	            {
	                "visibility": "on"
	            }
	        ]
	    },
	    {
	        "featureType": "water",
	        "stylers": [
	            {
	                "visibility": "simplified"
	            },
	            {
	                "saturation": -60
	            }
	        ]
	    }
	]
};

export default styles;