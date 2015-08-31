enterprise = Enterprise.create(
  name: "Acme Corp.",
  idp_entity_id: "https://app.onelogin.com/saml/metadata/468755",
  idp_sso_target_url: "https://v7.onelogin.com/trust/saml2/http-post/sso/468755",
  idp_slo_target_url: "https://v7.onelogin.com/trust/saml2/http-redirect/slo/468755",
  idp_cert: "-----BEGIN CERTIFICATE-----
MIIEFDCCAvygAwIBAgIUBvDB5WYcA+HOo/4oreMClnDKG4QwDQYJKoZIhvcNAQEF
BQAwVzELMAkGA1UEBhMCVVMxEDAOBgNVBAoMB1ZvbHVtZTcxFTATBgNVBAsMDE9u
ZUxvZ2luIElkUDEfMB0GA1UEAwwWT25lTG9naW4gQWNjb3VudCA2NzM5MzAeFw0x
NTA4MTYwMjE3NTZaFw0yMDA4MTcwMjE3NTZaMFcxCzAJBgNVBAYTAlVTMRAwDgYD
VQQKDAdWb2x1bWU3MRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAxHzAdBgNVBAMMFk9u
ZUxvZ2luIEFjY291bnQgNjczOTMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQCqLImUK0K34D6kKWpIOXVcAuNIYulD46Uz3h8WpCC9JZsc6+Nse7jvC5QV
jsJqctuoEcnHUX7tyUeY2RH8PHs7APAGCkWZot07rQ0Dpr3EK8yJSqOKCjDyhzM/
MCyxGHXwsaiCHPaUmi6PvHT7qMTtRGLL1CJf30h0D6hH07EOn0biNLJZFjrUL/Fp
vWwAxN/e/rtmiBpCXgeWcGvNGi6L/z1GICFON0++OBSK6QtGmNWfb7f8kA2q20yS
Em8EsfnE9fWL+h4SDA/0oQal5L6nRdY4j+OBnvXO8opMAuAtKWdoUb5bOJbLMMbs
JtYRgVh23iZNbVbvTEJywTVR/V5tAgMBAAGjgdcwgdQwDAYDVR0TAQH/BAIwADAd
BgNVHQ4EFgQURtFr30idIj5cpSYKV0v7JJ6hFPcwgZQGA1UdIwSBjDCBiYAURtFr
30idIj5cpSYKV0v7JJ6hFPehW6RZMFcxCzAJBgNVBAYTAlVTMRAwDgYDVQQKDAdW
b2x1bWU3MRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAxHzAdBgNVBAMMFk9uZUxvZ2lu
IEFjY291bnQgNjczOTOCFAbwweVmHAPhzqP+KK3jApZwyhuEMA4GA1UdDwEB/wQE
AwIHgDANBgkqhkiG9w0BAQUFAAOCAQEAd5fBLwWTjEq7Sefv6MXsDWCY+tbo0+Ys
jgajsDupJGF1PITEKVFXN+7p6J38C8NGnfdQLOzrYpkKBzyaJsDm67iCQD5rz6CL
MjF8n/vVVYuN0RcfPl28Du5g8gjhcF4wXldK/NiQ9gvckW005pswVxq0Xh3y0l4w
RBkf3lC+Uym8UhW5nBqSIdQ48pIuGYDInBxqjbpX4dUYL8R8LuDPvUfAXVPR64Us
wTsvlo/0p1sX89445zP+IPycIwo1W44t4tImhm3k2UUHKbuEzDKLYq2K2TyH/s7o
A5bYGY36o0HQqna1jAGDM8l3t7uwbpsMwf5O/CVPgcXBqUxJSX2J0g==
-----END CERTIFICATE-----\n",
  has_enabled_saml: true
)

first_name_field = TextField.create(
  title: "First name",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: true,
  match_polarity: true,
  match_weight: 0.1,
  enterprise: enterprise
)

last_name_field = TextField.create(
  title: "Last name",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: true,
  match_polarity: true,
  match_weight: 0.1,
  enterprise: enterprise
)

gender_field = SelectField.create(
  title: "Gender",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{
    title: "Male"
  }, {
    title: "Female"
  }]
)

age_field = NumericField.create(
  title: "Age",
  saml_attribute: "",
  gamification_value: 5,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.1,
  min: 18,
  max: 100,
  enterprise: enterprise
)

disabilities_field = SelectField.create(
  title: "Disabilities?",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{
    title: "Yes"
  }, {
    title: "No"
  }]
)

nationality_field = SelectField.create(
  title: "Nationality",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{title: "Afghanistan"},{title: "Albania"},{title: "Algeria"},{title: "American Samoa"},{title: "Andorra"},{title: "Angola"},{title: "Anguilla"},{title: "Antarctica"},{title: "Antigua and Barbuda"},{title: "Argentina"},{title: "Armenia"},{title: "Aruba"},{title: "Australia"},{title: "Austria"},{title: "Azerbaijan"},{title: "Bahamas"},{title: "Bahrain"},{title: "Bangladesh"},{title: "Barbados"},{title: "Belarus"},{title: "Belgium"},{title: "Belize"},{title: "Benin"},{title: "Bermuda"},{title: "Bhutan"},{title: "Bolivia"},{title: "Bosnia and Herzegovina"},{title: "Botswana"},{title: "Bouvet Island"},{title: "Brazil"},{title: "British Antarctic Territory"},{title: "British Indian Ocean Territory"},{title: "British Virgin Islands"},{title: "Brunei"},{title: "Bulgaria"},{title: "Burkina Faso"},{title: "Burundi"},{title: "Cambodia"},{title: "Cameroon"},{title: "Canada"},{title: "Canton and Enderbury Islands"},{title: "Cape Verde"},{title: "Cayman Islands"},{title: "Central African Republic"},{title: "Chad"},{title: "Chile"},{title: "China"},{title: "Christmas Island"},{title: "Cocos [Keeling] Islands"},{title: "Colombia"},{title: "Comoros"},{title: "Congo - Brazzaville"},{title: "Congo - Kinshasa"},{title: "Cook Islands"},{title: "Costa Rica"},{title: "Croatia"},{title: "Cuba"},{title: "Cyprus"},{title: "Czech Republic"},{title: "Côte d’Ivoire"},{title: "Denmark"},{title: "Djibouti"},{title: "Dominica"},{title: "Dominican Republic"},{title: "Dronning Maud Land"},{title: "East Germany"},{title: "Ecuador"},{title: "Egypt"},{title: "El Salvador"},{title: "Equatorial Guinea"},{title: "Eritrea"},{title: "Estonia"},{title: "Ethiopia"},{title: "Falkland Islands"},{title: "Faroe Islands"},{title: "Fiji"},{title: "Finland"},{title: "France"},{title: "French Guiana"},{title: "French Polynesia"},{title: "French Southern Territories"},{title: "French Southern and Antarctic Territories"},{title: "Gabon"},{title: "Gambia"},{title: "Georgia"},{title: "Germany"},{title: "Ghana"},{title: "Gibraltar"},{title: "Greece"},{title: "Greenland"},{title: "Grenada"},{title: "Guadeloupe"},{title: "Guam"},{title: "Guatemala"},{title: "Guernsey"},{title: "Guinea"},{title: "Guinea-Bissau"},{title: "Guyana"},{title: "Haiti"},{title: "Heard Island and McDonald Islands"},{title: "Honduras"},{title: "Hong Kong SAR China"},{title: "Hungary"},{title: "Iceland"},{title: "India"},{title: "Indonesia"},{title: "Iran"},{title: "Iraq"},{title: "Ireland"},{title: "Isle of Man"},{title: "Israel"},{title: "Italy"},{title: "Jamaica"},{title: "Japan"},{title: "Jersey"},{title: "Johnston Island"},{title: "Jordan"},{title: "Kazakhstan"},{title: "Kenya"},{title: "Kiribati"},{title: "Kuwait"},{title: "Kyrgyzstan"},{title: "Laos"},{title: "Latvia"},{title: "Lebanon"},{title: "Lesotho"},{title: "Liberia"},{title: "Libya"},{title: "Liechtenstein"},{title: "Lithuania"},{title: "Luxembourg"},{title: "Macau SAR China"},{title: "Macedonia"},{title: "Madagascar"},{title: "Malawi"},{title: "Malaysia"},{title: "Maldives"},{title: "Mali"},{title: "Malta"},{title: "Marshall Islands"},{title: "Martinique"},{title: "Mauritania"},{title: "Mauritius"},{title: "Mayotte"},{title: "Metropolitan France"},{title: "Mexico"},{title: "Micronesia"},{title: "Midway Islands"},{title: "Moldova"},{title: "Monaco"},{title: "Mongolia"},{title: "Montenegro"},{title: "Montserrat"},{title: "Morocco"},{title: "Mozambique"},{title: "Myanmar [Burma]"},{title: "Namibia"},{title: "Nauru"},{title: "Nepal"},{title: "Netherlands"},{title: "Netherlands Antilles"},{title: "Neutral Zone"},{title: "New Caledonia"},{title: "New Zealand"},{title: "Nicaragua"},{title: "Niger"},{title: "Nigeria"},{title: "Niue"},{title: "Norfolk Island"},{title: "North Korea"},{title: "North Vietnam"},{title: "Northern Mariana Islands"},{title: "Norway"},{title: "Oman"},{title: "Pacific Islands Trust Territory"},{title: "Pakistan"},{title: "Palau"},{title: "Palestinian Territories"},{title: "Panama"},{title: "Panama Canal Zone"},{title: "Papua New Guinea"},{title: "Paraguay"},{title: "People's Democratic Republic of Yemen"},{title: "Peru"},{title: "Philippines"},{title: "Pitcairn Islands"},{title: "Poland"},{title: "Portugal"},{title: "Puerto Rico"},{title: "Qatar"},{title: "Romania"},{title: "Russia"},{title: "Rwanda"},{title: "Réunion"},{title: "Saint Barthélemy"},{title: "Saint Helena"},{title: "Saint Kitts and Nevis"},{title: "Saint Lucia"},{title: "Saint Martin"},{title: "Saint Pierre and Miquelon"},{title: "Saint Vincent and the Grenadines"},{title: "Samoa"},{title: "San Marino"},{title: "Saudi Arabia"},{title: "Senegal"},{title: "Serbia"},{title: "Serbia and Montenegro"},{title: "Seychelles"},{title: "Sierra Leone"},{title: "Singapore"},{title: "Slovakia"},{title: "Slovenia"},{title: "Solomon Islands"},{title: "Somalia"},{title: "South Africa"},{title: "South Georgia and the South Sandwich Islands"},{title: "South Korea"},{title: "Spain"},{title: "Sri Lanka"},{title: "Sudan"},{title: "Suriname"},{title: "Svalbard and Jan Mayen"},{title: "Swaziland"},{title: "Sweden"},{title: "Switzerland"},{title: "Syria"},{title: "São Tomé and Príncipe"},{title: "Taiwan"},{title: "Tajikistan"},{title: "Tanzania"},{title: "Thailand"},{title: "Timor-Leste"},{title: "Togo"},{title: "Tokelau"},{title: "Tonga"},{title: "Trinidad and Tobago"},{title: "Tunisia"},{title: "Turkey"},{title: "Turkmenistan"},{title: "Turks and Caicos Islands"},{title: "Tuvalu"},{title: "U.S. Minor Outlying Islands"},{title: "U.S. Miscellaneous Pacific Islands"},{title: "U.S. Virgin Islands"},{title: "Uganda"},{title: "Ukraine"},{title: "Union of Soviet Socialist Republics"},{title: "United Arab Emirates"},{title: "United Kingdom"},{title: "United States"},{title: "Unknown or Invalid Region"},{title: "Uruguay"},{title: "Uzbekistan"},{title: "Vanuatu"},{title: "Vatican City"},{title: "Venezuela"},{title: "Vietnam"},{title: "Wake Island"},{title: "Wallis and Futuna"},{title: "Western Sahara"},{title: "Yemen"},{title: "Zambia"},{title: "Zimbabwe"},{title: "Åland Islands"}]
)

belief_field = SelectField.create(
  title: "Belief",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{title: "Atheism"},{title: "Christianity"},{title: "Islam"},{title: "Hinduism"},{title: "Buddhism"},{title: "Sikhism"},{title: "Agnostic"},{title: "Spiritual"},{title: "Other"}]
)

languages_field = CheckboxField.create(
  title: "Spoken languages",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{title:"English"},{title:"Mandarin"},{title:"Spanish"},{title:"Hindi"},{title:"Arabic"},{title:"Russian"},{title:"Portuguese"},{title:"Bengali"},{title:"French"},{title:"Malay"},{title:"Urdu"},{title:"Japanese"},{title:"Persian"},{title:"German"},{title:"Javanese"},{title:"Telugu"},{title:"Turkish"},{title:"Tamil"},{title:"Korean"},{title:"Wu (Shanghainese)"},{title:"Marathi"},{title:"Vietnamese"},{title:"Italian"},{title:"Western Punjabi"},{title:"Yue (Cantonese)"}]
)

ethnicity_field = SelectField.create(
  title: "Ethnicity",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{title:"Caucasian"},{title:"Hispanic"},{title:"Latino"},{title:"Black or African American"},{title:"American Indian"},{title:"Asian"},{title:"Indian"},{title:"Native Hawaiian"},{title:"Pacific Islander"},{title:"Other"}]
)

kids_field = SelectField.create(
  title: "Status",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{
    title: "Single"
  }, {
    title: "In a relationship"
  }, {
    title: "Married"
  }, {
    title: "Single parent"
  }]
)

orientation_field = SelectField.create(
  title: "LGBT?",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{
    title: "Yes"
  }, {
    title: "No"
  }]
)

hobbies_field = SelectField.create(
  title: "Hobbies",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{title: "3D printing"}, {title:"Amateur radio"}, {title:"Acting"}, {title:"Baton twirling"}, {title:"Board games"}, {title:"Book restoration"}, {title:"Cabaret"}, {title:"Calligraphy"}, {title:"Candle making"}, {title:"Computer programming"}, {title:"Cooking"}, {title:"Coloring"}, {title:"Cosplaying"}, {title:"Couponing"}, {title:"Creative writing"}, {title:"Crocheting"}, {title:"Cryptography"}, {title:"Dance"}, {title:"Digital arts"}, {title:"Drama"}, {title:"Drawing"}, {title:"Do it yourself (DIY)"}, {title:"Electronics"}, {title:"Embroidery"}, {title:"Fashion"}, {title:"Flower arranging"}, {title:"Foreign language learning"}, {title:"Gaming (tabletop games and role-playing games)"}, {title:"Gambling"}, {title:"Genealogy"}, {title:"Glassblowing"}, {title:"Homebrewing"}, {title:"Ice skating"}, {title:"Jewelry making"}, {title:"Jigsaw puzzles"}, {title:"Juggling"}, {title:"Knapping"}, {title:"Knitting"}, {title:"Kabaddi"}, {title:"Knife making"}, {title:"Lacemaking"}, {title:"Lapidary"}, {title:"Leather crafting"}, {title:"Lego building"}, {title:"Lockpicking"}, {title:"Machining"}, {title:"Macrame"}, {title:"Metalworking"}, {title:"Magic"}, {title:"Model building"}, {title:"Listening to music"}, {title:"Origami"}, {title:"Painting"}, {title:"Playing musical instruments"}, {title:"Pets"}, {title:"Pottery"}, {title:"Puzzles"}, {title:"Quilting"}, {title:"Reading"}, {title:"Scrapbooking"}, {title:"Sculpting"}, {title:"Sewing"}, {title:"Singing"}, {title:"Sketching"}, {title:"Soapmaking"}, {title:"Sports"}, {title:"Stand-up comedy"}, {title:"Sudoku"}, {title:"Table tennis"}, {title:"Taxidermy"}, {title:"Video gaming"}, {title:"Watching movies"}, {title:"Web surfing"}, {title:"Whittling"}, {title:"Wood carving"}, {title:"Woodworking"}, {title:"Worldbuilding"}, {title:"Writing"}, {title:"Yoga"}, {title:"Yo-yoing"}, {title:"Air sports"}, {title:"Archery"}, {title:"Astronomy"}, {title:"Backpacking"}, {title:"BASE jumping"}, {title:"Baseball"}, {title:"Basketball"}, {title:"Beekeeping"}, {title:"Bird watching"}, {title:"Blacksmithing"}, {title:"Board sports"}, {title:"Bodybuilding"}, {title:"Brazilian jiu-jitsu"}, {title:"Cycling"}, {title:"Dowsing"}, {title:"Driving"}, {title:"Fishing"}, {title:"Flag Football"}, {title:"Flying"}, {title:"Flying disc"}, {title:"Foraging"}, {title:"Gardening"}, {title:"Geocaching"}, {title:"Ghost hunting"}, {title:"Graffiti"}, {title:"Gunsmithing"}, {title:"Handball"}, {title:"Hiking"}, {title:"Hooping"}, {title:"Horseback riding"}, {title:"Hunting"}, {title:"Inline skating"}, {title:"Jogging"}, {title:"Kayaking"}, {title:"Kite flying"}, {title:"Kitesurfing"}, {title:"LARPing"}, {title:"Letterboxing"}, {title:"Metal detecting"}, {title:"Motor sports"}, {title:"Mountain biking"}, {title:"Mountaineering"}, {title:"Mushroom hunting/Mycology"}, {title:"Netball"}, {title:"Nordic skating"}, {title:"Orienteering"}, {title:"Paintball"}, {title:"Parkour"}, {title:"Photography"}, {title:"Polo"}, {title:"Rafting"}, {title:"Rappelling"}, {title:"Rock climbing"}, {title:"Roller skating"}, {title:"Rugby"}, {title:"Running"}, {title:"Sailing"}, {title:"Sand art"}, {title:"Scouting"}, {title:"Scuba diving"}, {title:"Sculling or Rowing"}, {title:"Shooting"}, {title:"Shopping"}, {title:"Skateboarding"}, {title:"Skiing"}, {title:"Skimboarding"}, {title:"Skydiving"}, {title:"Slacklining"}, {title:"Snowboarding"}, {title:"Stone skipping"}, {title:"Surfing"}, {title:"Swimming"}, {title:"Taekwondo"}, {title:"Tai chi"}, {title:"Urban exploration"}, {title:"Vacation"}, {title:"Vehicle restoration"}, {title:"Water sports"}, {title:"Figure collecting"}, {title:"Antiquing"}, {title:"Art collecting"}, {title:"Book collecting"}, {title:"Card collecting"}, {title:"Coin collecting"}, {title:"Comic book collecting"}, {title:"Deltiology (postcard collecting)"}, {title:"Die-cast toy"}, {title:"Element collecting"}, {title:"Movie and movie memorabilia collecting"}, {title:"Record collecting"}, {title:"Stamp collecting"}, {title:"Video game collecting"}, {title:"Vintage cars"}, {title:"Weapon collecting"}, {title:"Antiquities"}, {title:"Auto audiophilia"}, {title:"Flower collecting and pressing"}, {title:"Fossil hunting"}, {title:"Insect collecting"}, {title:"Metal detecting"}, {title:"Stone collecting"}, {title:"Mineral collecting"}, {title:"Rock balancing"}, {title:"Sea glass collecting"}, {title:"Seashell collecting"}, {title:"Aqua-lung"}, {title:"Animal fancy"}, {title:"Badminton"}, {title:"Baton Twirling"}, {title:"Billiards"}, {title:"Bowling"}, {title:"Boxing"}, {title:"Bridge"}, {title:"Cheerleading"}, {title:"Chess"}, {title:"Color guard"}, {title:"Curling"}, {title:"Dancing"}, {title:"Darts"}, {title:"Debate"}, {title:"Fencing"}, {title:"Go"}, {title:"Gymnastics"}, {title:"Marbles"}, {title:"Martial arts"}, {title:"Mahjong"}, {title:"Poker"}, {title:"Slot car racing"}, {title:"Table football"}, {title:"Video Games"}, {title:"Volleyball"}, {title:"Weightlifting"}, {title:"Airsoft"}, {title:"American football"}, {title:"Archery"}, {title:"Association football"}, {title:"Australian rules football"}, {title:"Auto racing"}, {title:"Baseball"}, {title:"Beach Volleyball"}, {title:"Breakdancing"}, {title:"Climbing"}, {title:"Cricket"}, {title:"Cycling"}, {title:"Disc golf"}, {title:"Dog sport"}, {title:"Equestrianism"}, {title:"Exhibition drill"}, {title:"Field hockey"}, {title:"Figure skating"}, {title:"Fishing"}, {title:"Ultimate Frisbee "}, {title:"Footbag"}, {title:"Golfing"}, {title:"Handball"}, {title:"Ice hockey"}, {title:"Judo"}, {title:"Jukskei"}, {title:"Kart racing"}, {title:"Knife throwing"}, {title:"Lacrosse"}, {title:"Laser tag"}, {title:"Model aircraft"}, {title:"Pigeon racing"}, {title:"Racquetball"}, {title:"Radio-controlled car racing"}, {title:"Roller derby"}, {title:"Rugby league football"}, {title:"Shooting sport"}, {title:"Skateboarding"}, {title:"Speed skating"}, {title:"Squash"}, {title:"Surfing"}, {title:"Swimming"}, {title:"Table tennis"}, {title:"Tennis"}, {title:"Tour skating"}, {title:"Triathlon"}, {title:"Volleyball"}, {title:"Fishkeeping"}, {title:"Microscopy"}, {title:"Reading"}, {title:"Shortwave listening"}, {title:"Videophilia"}, {title:"Aircraft spotting"}, {title:"Amateur astronomy"}, {title:"Amateur geology"}, {title:"Astrology"}, {title:"Birdwatching"}, {title:"Bus spotting"}, {title:"Geocaching"}, {title:"Gongoozling"}, {title:"Herping"}, {title:"Meteorology"}, {title:"People watching"}, {title:"Trainspotting"}, {title:"Traveling"}]
)

# Professional fields
title_field = TextField.create(
  title: "Current title",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise
)

education_field = SelectField.create(
  title: "Education level",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{
    title: "High School"
  },
  {
    title: "Bachelor's degree"
  },
  {
    title: "Master's degree"
  },
  {
    title: "PhD"
  }]
)

certifications_field = CheckboxField.create(
  title: "Certifications",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{
    title: "Microsoft Certified Partner"
  }, {
    title: "Google Partner"
  }, {
    title: "Apple Genius"
  }]
)

experience_field = NumericField.create(
  title: "Experience in your field (in years)",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  min: 0,
  max: 100,
  enterprise: enterprise
)

countries_worked_field = SelectField.create(
  title: "Countries worked in",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{title: "Afghanistan"},{title: "Albania"},{title: "Algeria"},{title: "American Samoa"},{title: "Andorra"},{title: "Angola"},{title: "Anguilla"},{title: "Antarctica"},{title: "Antigua and Barbuda"},{title: "Argentina"},{title: "Armenia"},{title: "Aruba"},{title: "Australia"},{title: "Austria"},{title: "Azerbaijan"},{title: "Bahamas"},{title: "Bahrain"},{title: "Bangladesh"},{title: "Barbados"},{title: "Belarus"},{title: "Belgium"},{title: "Belize"},{title: "Benin"},{title: "Bermuda"},{title: "Bhutan"},{title: "Bolivia"},{title: "Bosnia and Herzegovina"},{title: "Botswana"},{title: "Bouvet Island"},{title: "Brazil"},{title: "British Antarctic Territory"},{title: "British Indian Ocean Territory"},{title: "British Virgin Islands"},{title: "Brunei"},{title: "Bulgaria"},{title: "Burkina Faso"},{title: "Burundi"},{title: "Cambodia"},{title: "Cameroon"},{title: "Canada"},{title: "Canton and Enderbury Islands"},{title: "Cape Verde"},{title: "Cayman Islands"},{title: "Central African Republic"},{title: "Chad"},{title: "Chile"},{title: "China"},{title: "Christmas Island"},{title: "Cocos [Keeling] Islands"},{title: "Colombia"},{title: "Comoros"},{title: "Congo - Brazzaville"},{title: "Congo - Kinshasa"},{title: "Cook Islands"},{title: "Costa Rica"},{title: "Croatia"},{title: "Cuba"},{title: "Cyprus"},{title: "Czech Republic"},{title: "Côte d’Ivoire"},{title: "Denmark"},{title: "Djibouti"},{title: "Dominica"},{title: "Dominican Republic"},{title: "Dronning Maud Land"},{title: "East Germany"},{title: "Ecuador"},{title: "Egypt"},{title: "El Salvador"},{title: "Equatorial Guinea"},{title: "Eritrea"},{title: "Estonia"},{title: "Ethiopia"},{title: "Falkland Islands"},{title: "Faroe Islands"},{title: "Fiji"},{title: "Finland"},{title: "France"},{title: "French Guiana"},{title: "French Polynesia"},{title: "French Southern Territories"},{title: "French Southern and Antarctic Territories"},{title: "Gabon"},{title: "Gambia"},{title: "Georgia"},{title: "Germany"},{title: "Ghana"},{title: "Gibraltar"},{title: "Greece"},{title: "Greenland"},{title: "Grenada"},{title: "Guadeloupe"},{title: "Guam"},{title: "Guatemala"},{title: "Guernsey"},{title: "Guinea"},{title: "Guinea-Bissau"},{title: "Guyana"},{title: "Haiti"},{title: "Heard Island and McDonald Islands"},{title: "Honduras"},{title: "Hong Kong SAR China"},{title: "Hungary"},{title: "Iceland"},{title: "India"},{title: "Indonesia"},{title: "Iran"},{title: "Iraq"},{title: "Ireland"},{title: "Isle of Man"},{title: "Israel"},{title: "Italy"},{title: "Jamaica"},{title: "Japan"},{title: "Jersey"},{title: "Johnston Island"},{title: "Jordan"},{title: "Kazakhstan"},{title: "Kenya"},{title: "Kiribati"},{title: "Kuwait"},{title: "Kyrgyzstan"},{title: "Laos"},{title: "Latvia"},{title: "Lebanon"},{title: "Lesotho"},{title: "Liberia"},{title: "Libya"},{title: "Liechtenstein"},{title: "Lithuania"},{title: "Luxembourg"},{title: "Macau SAR China"},{title: "Macedonia"},{title: "Madagascar"},{title: "Malawi"},{title: "Malaysia"},{title: "Maldives"},{title: "Mali"},{title: "Malta"},{title: "Marshall Islands"},{title: "Martinique"},{title: "Mauritania"},{title: "Mauritius"},{title: "Mayotte"},{title: "Metropolitan France"},{title: "Mexico"},{title: "Micronesia"},{title: "Midway Islands"},{title: "Moldova"},{title: "Monaco"},{title: "Mongolia"},{title: "Montenegro"},{title: "Montserrat"},{title: "Morocco"},{title: "Mozambique"},{title: "Myanmar [Burma]"},{title: "Namibia"},{title: "Nauru"},{title: "Nepal"},{title: "Netherlands"},{title: "Netherlands Antilles"},{title: "Neutral Zone"},{title: "New Caledonia"},{title: "New Zealand"},{title: "Nicaragua"},{title: "Niger"},{title: "Nigeria"},{title: "Niue"},{title: "Norfolk Island"},{title: "North Korea"},{title: "North Vietnam"},{title: "Northern Mariana Islands"},{title: "Norway"},{title: "Oman"},{title: "Pacific Islands Trust Territory"},{title: "Pakistan"},{title: "Palau"},{title: "Palestinian Territories"},{title: "Panama"},{title: "Panama Canal Zone"},{title: "Papua New Guinea"},{title: "Paraguay"},{title: "People's Democratic Republic of Yemen"},{title: "Peru"},{title: "Philippines"},{title: "Pitcairn Islands"},{title: "Poland"},{title: "Portugal"},{title: "Puerto Rico"},{title: "Qatar"},{title: "Romania"},{title: "Russia"},{title: "Rwanda"},{title: "Réunion"},{title: "Saint Barthélemy"},{title: "Saint Helena"},{title: "Saint Kitts and Nevis"},{title: "Saint Lucia"},{title: "Saint Martin"},{title: "Saint Pierre and Miquelon"},{title: "Saint Vincent and the Grenadines"},{title: "Samoa"},{title: "San Marino"},{title: "Saudi Arabia"},{title: "Senegal"},{title: "Serbia"},{title: "Serbia and Montenegro"},{title: "Seychelles"},{title: "Sierra Leone"},{title: "Singapore"},{title: "Slovakia"},{title: "Slovenia"},{title: "Solomon Islands"},{title: "Somalia"},{title: "South Africa"},{title: "South Georgia and the South Sandwich Islands"},{title: "South Korea"},{title: "Spain"},{title: "Sri Lanka"},{title: "Sudan"},{title: "Suriname"},{title: "Svalbard and Jan Mayen"},{title: "Swaziland"},{title: "Sweden"},{title: "Switzerland"},{title: "Syria"},{title: "São Tomé and Príncipe"},{title: "Taiwan"},{title: "Tajikistan"},{title: "Tanzania"},{title: "Thailand"},{title: "Timor-Leste"},{title: "Togo"},{title: "Tokelau"},{title: "Tonga"},{title: "Trinidad and Tobago"},{title: "Tunisia"},{title: "Turkey"},{title: "Turkmenistan"},{title: "Turks and Caicos Islands"},{title: "Tuvalu"},{title: "U.S. Minor Outlying Islands"},{title: "U.S. Miscellaneous Pacific Islands"},{title: "U.S. Virgin Islands"},{title: "Uganda"},{title: "Ukraine"},{title: "Union of Soviet Socialist Republics"},{title: "United Arab Emirates"},{title: "United Kingdom"},{title: "United States"},{title: "Unknown or Invalid Region"},{title: "Uruguay"},{title: "Uzbekistan"},{title: "Vanuatu"},{title: "Vatican City"},{title: "Venezuela"},{title: "Vietnam"},{title: "Wake Island"},{title: "Wallis and Futuna"},{title: "Western Sahara"},{title: "Yemen"},{title: "Zambia"},{title: "Zimbabwe"},{title: "Åland Islands"}]
)

military_field = SelectField.create(
  title: "Veteran?",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{
    title: "Yes"
  }, {
    title: "No"
  }]
)

office_location_field = SelectField.create(
  title: "Office location",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise,
  options_attributes: [{
    title: "NA"
  }, {
    title: "EU"
  }, {
    title: "CN"
  }, {
    title: "JP"
  }]
)

seniority_field = NumericField.create(
  title: "Seniority (in years)",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  min: 0,
  max: 40,
  enterprise: enterprise
)


admin = Admin.create(
  enterprise: enterprise,
  first_name: "Francis",
  last_name: "Marineau",
  email: "frank.marineau@gmail.com",
  password: "password",
  password_confirmation: "password"
)