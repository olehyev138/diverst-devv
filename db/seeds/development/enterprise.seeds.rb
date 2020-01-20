spinner = TTY::Spinner.new(":spinner Creating enterprises...", format: :spin_2)
spinner.run do |spinner|
  Enterprise.create(
    name: "Diverst Inc",
    sp_entity_id: ( (0...8).map { (65 + rand(26)).chr }.join ), # Generate random string
    idp_entity_id: 'https://app.onelogin.com/saml/metadata/468755',
    idp_sso_target_url: 'https://v7.onelogin.com/trust/saml2/http-post/sso/468755',
    idp_slo_target_url: 'https://v7.onelogin.com/trust/saml2/http-redirect/slo/468755',
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
    has_enabled_saml: false,
    theme_id: 1,
    disable_emails: true,
    created_at: 2.years.ago,
    time_zone: ActiveSupport::TimeZone.find_tzinfo('UTC').name
  )

  Enterprise.create(
    name: "BAD ENTERPRISE",
    sp_entity_id: ( (0...8).map { (65 + rand(26)).chr }.join ), # Generate random string
    idp_entity_id: 'https://app.onelogin.com/saml/metadata/468755',
    idp_sso_target_url: 'https://v7.onelogin.com/trust/saml2/http-post/sso/468755',
    idp_slo_target_url: 'https://v7.onelogin.com/trust/saml2/http-redirect/slo/468755',
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
    has_enabled_saml: true,
    theme_id: 1,
    disable_emails: true,
    created_at: 2.years.ago,
    time_zone: ActiveSupport::TimeZone.find_tzinfo('UTC').name
  )

  Enterprise.all.each do |enterprise|
    SelectField.create(
      title: 'Gender',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Male
Female"
    )

    DateField.create(
      title: 'Date of birth',
      saml_attribute: '',
      gamification_value: 5,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise
    )

    SelectField.create(
      title: 'Disabilities?',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Yes
No"
    )

    SelectField.create(
      title: 'Nationality',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Afghanistan
Albania
Algeria
American Samoa
Andorra
Angola
Anguilla
Antarctica
Antigua and Barbuda
Argentina
Armenia
Aruba
Australia
Austria
Azerbaijan
Bahamas
Bahrain
Bangladesh
Barbados
Belarus
Belgium
Belize
Benin
Bermuda
Bhutan
Bolivia
Bosnia and Herzegovina
Botswana
Bouvet Island
Brazil
British Antarctic Territory
British Indian Ocean Territory
British Virgin Islands
Brunei
Bulgaria
Burkina Faso
Burundi
Cambodia
Cameroon
Canada
Canton and Enderbury Islands
Cape Verde
Cayman Islands
Central African Republic
Chad
Chile
China
Christmas Island
Cocos [Keeling] Islands
Colombia
Comoros
Congo - Brazzaville
Congo - Kinshasa
Cook Islands
Costa Rica
Croatia
Cuba
Cyprus
Czech Republic
Côte d’Ivoire
Denmark
Djibouti
Dominica
Dominican Republic
Dronning Maud Land
East Germany
Ecuador
Egypt
El Salvador
Equatorial Guinea
Eritrea
Estonia
Ethiopia
Falkland Islands
Faroe Islands
Fiji
Finland
France
French Guiana
French Polynesia
French Southern Territories
French Southern and Antarctic Territories
Gabon
Gambia
Georgia
Germany
Ghana
Gibraltar
Greece
Greenland
Grenada
Guadeloupe
Guam
Guatemala
Guernsey
Guinea
Guinea-Bissau
Guyana
Haiti
Heard Island and McDonald Islands
Honduras
Hong Kong SAR China
Hungary
Iceland
India
Indonesia
Iran
Iraq
Ireland
Isle of Man
Israel
Italy
Jamaica
Japan
Jersey
Johnston Island
Jordan
Kazakhstan
Kenya
Kiribati
Kuwait
Kyrgyzstan
Laos
Latvia
Lebanon
Lesotho
Liberia
Libya
Liechtenstein
Lithuania
Luxembourg
Macau SAR China
Macedonia
Madagascar
Malawi
Malaysia
Maldives
Mali
Malta
Marshall Islands
Martinique
Mauritania
Mauritius
Mayotte
Metropolitan France
Mexico
Micronesia
Midway Islands
Moldova
Monaco
Mongolia
Montenegro
Montserrat
Morocco
Mozambique
Myanmar [Burma]
Namibia
Nauru
Nepal
Netherlands
Netherlands Antilles
Neutral Zone
New Caledonia
New Zealand
Nicaragua
Niger
Nigeria
Niue
Norfolk Island
North Korea
North Vietnam
Northern Mariana Islands
Norway
Oman
Pacific Islands Trust Territory
Pakistan
Palau
Palestinian Territories
Panama
Panama Canal Zone
Papua New Guinea
Paraguay
People's Democratic Republic of Yemen
Peru
Philippines
Pitcairn Islands
Poland
Portugal
Puerto Rico
Qatar
Romania
Russia
Rwanda
Réunion
Saint Barthélemy
Saint Helena
Saint Kitts and Nevis
Saint Lucia
Saint Martin
Saint Pierre and Miquelon
Saint Vincent and the Grenadines
Samoa
San Marino
Saudi Arabia
Senegal
Serbia
Serbia and Montenegro
Seychelles
Sierra Leone
Singapore
Slovakia
Slovenia
Solomon Islands
Somalia
South Africa
South Georgia and the South Sandwich Islands
South Korea
Spain
Sri Lanka
Sudan
Suriname
Svalbard and Jan Mayen
Swaziland
Sweden
Switzerland
Syria
São Tomé and Príncipe
Taiwan
Tajikistan
Tanzania
Thailand
Timor-Leste
Togo
Tokelau
Tonga
Trinidad and Tobago
Tunisia
Turkey
Turkmenistan
Turks and Caicos Islands
Tuvalu
U.S. Minor Outlying Islands
U.S. Miscellaneous Pacific Islands
U.S. Virgin Islands
Uganda
Ukraine
Union of Soviet Socialist Republics
United Arab Emirates
United Kingdom
United States
Unknown or Invalid Region
Uruguay
Uzbekistan
Vanuatu
Vatican City
Venezuela
Vietnam
Wake Island
Wallis and Futuna
Western Sahara
Yemen
Zambia
Zimbabwe
Åland Islands"
    )

    SelectField.create(
      title: 'Belief',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Atheism
Christianity
Islam
Hinduism
Buddhism
Sikhism
Agnostic
Spiritual
Other"
    )

    CheckboxField.create(
      title: 'Spoken languages',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      alternative_layout: true,
      options_text: "English
Mandarin
Spanish
Hindi
Arabic
Russian
Portuguese
Bengali
French
Malay
Urdu
Japanese
Persian
German
Javanese
Telugu
Turkish
Tamil
Korean
Wu (Shanghainese)
Marathi
Vietnamese
Italian
Western Punjabi
Yue (Cantonese)"
    )

    SelectField.create(
      title: 'Ethnicity',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Caucasian
Hispanic
Latino
Black or African American
American Indian
Asian
Indian
Native Hawaiian
Pacific Islander
Other"
    )

    SelectField.create(
      title: 'Status',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Single
In a relationship
Married
Single parent"
    )

    SelectField.create(
      title: 'LGBT?',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Yes
No"
    )

    CheckboxField.create(
      title: 'Hobbies',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      alternative_layout: true,
      field_definer: enterprise,
      options_text: "3D printing
Amateur radio
Acting
Baton twirling
Board games
Book restoration
Cabaret
Calligraphy
Candle making
Computer programming
Cooking
Coloring
Cosplaying
Couponing
Creative writing
Crocheting
Cryptography
Dance
Digital arts
Drama
Drawing
Do it yourself (DIY)
Electronics
Embroidery
Fashion
Flower arranging
Foreign language learning
Gaming (tabletop games and role-playing games)
Gambling
Genealogy
Glassblowing
Homebrewing
Ice skating
Jewelry making
Jigsaw puzzles
Juggling
Knapping
Knitting
Kabaddi
Knife making
Lacemaking
Lapidary
Leather crafting
Lego building
Lockpicking
Machining
Macrame
Metalworking
Magic
Model building
Listening to music
Origami
Painting
Playing musical instruments
Pets
Pottery
Puzzles
Quilting
Reading
Scrapbooking
Sculpting
Sewing
Singing
Sketching
Soapmaking
Sports
Stand-up comedy
Sudoku
Table tennis
Taxidermy
Video gaming
Watching movies
Web surfing
Whittling
Wood carving
Woodworking
Worldbuilding
Writing
Yoga
Yo-yoing
Air sports
Archery
Astronomy
Backpacking
BASE jumping
Baseball
Basketball
Beekeeping
Bird watching
Blacksmithing
Board sports
Bodybuilding
Brazilian jiu-jitsu
Cycling
Dowsing
Driving
Fishing
Flag Football
Flying
Flying disc
Foraging
Gardening
Geocaching
Ghost hunting
Graffiti
Gunsmithing
Handball
Hiking
Hooping
Horseback riding
Hunting
Inline skating
Jogging
Kayaking
Kite flying
Kitesurfing
LARPing
Letterboxing
Metal detecting
Motor sports
Mountain biking
Mountaineering
Mushroom hunting/Mycology
Netball
Nordic skating
Orienteering
Paintball
Parkour
Photography
Polo
Rafting
Rappelling
Rock climbing
Roller skating
Rugby
Running
Sailing
Sand art
Scouting
Scuba diving
Sculling or Rowing
Shooting
Shopping
Skateboarding
Skiing
Skimboarding
Skydiving
Slacklining
Snowboarding
Stone skipping
Surfing
Swimming
Taekwondo
Tai chi
Urban exploration
Vacation
Vehicle restoration
Water sports
Figure collecting
Antiquing
Art collecting
Book collecting
Card collecting
Coin collecting
Comic book collecting
Deltiology (postcard collecting)
Die-cast toy
Element collecting
Movie and movie memorabilia collecting
Record collecting
Stamp collecting
Video game collecting
Vintage cars
Weapon collecting
Antiquities
Auto audiophilia
Flower collecting and pressing
Fossil hunting
Insect collecting
Metal detecting
Stone collecting
Mineral collecting
Rock balancing
Sea glass collecting
Seashell collecting
Aqua-lung
Animal fancy
Badminton
Baton Twirling
Billiards
Bowling
Boxing
Bridge
Cheerleading
Chess
Color guard
Curling
Dancing
Darts
Debate
Fencing
Go
Gymnastics
Marbles
Martial arts
Mahjong
Poker
Slot car racing
Table football
Video Games
Volleyball
Weightlifting
Airsoft
American football
Archery
Association football
Australian rules football
Auto racing
Baseball
Beach Volleyball
Breakdancing
Climbing
Cricket
Cycling
Disc golf
Dog sport
Equestrianism
Exhibition drill
Field hockey
Figure skating
Fishing
Ultimate Frisbee
Footbag
Golfing
Handball
Ice hockey
Judo
Jukskei
Kart racing
Knife throwing
Lacrosse
Laser tag
Model aircraft
Pigeon racing
Racquetball
Radio-controlled car racing
Roller derby
Rugby league football
Shooting sport
Skateboarding
Speed skating
Squash
Surfing
Swimming
Table tennis
Tennis
Tour skating
Triathlon
Volleyball
Fishkeeping
Microscopy
Reading
Shortwave listening
Videophilia
Aircraft spotting
Amateur astronomy
Amateur geology
Astrology
Birdwatching
Bus spotting
Geocaching
Gongoozling
Herping
Meteorology
People watching
Trainspotting
Traveling"
    )

    # Professional fields
    TextField.create(
      title: 'Current title',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise
    )

    SelectField.create(
      title: 'Education level',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "High School
Bachelor's degree
Master's degree
PhD"
    )

    CheckboxField.create(
      title: 'Certifications',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Microsoft Certified Partner
Google Partner
Apple Genius"
    )

    NumericField.create(
      title: 'Experience in your field (in years)',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      min: 0,
      max: 100,
      field_definer: enterprise
    )

    CheckboxField.create(
      title: 'Countries worked in',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      alternative_layout: true,
      options_text: "Afghanistan
Albania
Algeria
American Samoa
Andorra
Angola
Anguilla
Antarctica
Antigua and Barbuda
Argentina
Armenia
Aruba
Australia
Austria
Azerbaijan
Bahamas
Bahrain
Bangladesh
Barbados
Belarus
Belgium
Belize
Benin
Bermuda
Bhutan
Bolivia
Bosnia and Herzegovina
Botswana
Bouvet Island
Brazil
British Antarctic Territory
British Indian Ocean Territory
British Virgin Islands
Brunei
Bulgaria
Burkina Faso
Burundi
Cambodia
Cameroon
Canada
Canton and Enderbury Islands
Cape Verde
Cayman Islands
Central African Republic
Chad
Chile
China
Christmas Island
Cocos [Keeling] Islands
Colombia
Comoros
Congo - Brazzaville
Congo - Kinshasa
Cook Islands
Costa Rica
Croatia
Cuba
Cyprus
Czech Republic
Côte d’Ivoire
Denmark
Djibouti
Dominica
Dominican Republic
Dronning Maud Land
East Germany
Ecuador
Egypt
El Salvador
Equatorial Guinea
Eritrea
Estonia
Ethiopia
Falkland Islands
Faroe Islands
Fiji
Finland
France
French Guiana
French Polynesia
French Southern Territories
French Southern and Antarctic Territories
Gabon
Gambia
Georgia
Germany
Ghana
Gibraltar
Greece
Greenland
Grenada
Guadeloupe
Guam
Guatemala
Guernsey
Guinea
Guinea-Bissau
Guyana
Haiti
Heard Island and McDonald Islands
Honduras
Hong Kong SAR China
Hungary
Iceland
India
Indonesia
Iran
Iraq
Ireland
Isle of Man
Israel
Italy
Jamaica
Japan
Jersey
Johnston Island
Jordan
Kazakhstan
Kenya
Kiribati
Kuwait
Kyrgyzstan
Laos
Latvia
Lebanon
Lesotho
Liberia
Libya
Liechtenstein
Lithuania
Luxembourg
Macau SAR China
Macedonia
Madagascar
Malawi
Malaysia
Maldives
Mali
Malta
Marshall Islands
Martinique
Mauritania
Mauritius
Mayotte
Metropolitan France
Mexico
Micronesia
Midway Islands
Moldova
Monaco
Mongolia
Montenegro
Montserrat
Morocco
Mozambique
Myanmar [Burma]
Namibia
Nauru
Nepal
Netherlands
Netherlands Antilles
Neutral Zone
New Caledonia
New Zealand
Nicaragua
Niger
Nigeria
Niue
Norfolk Island
North Korea
North Vietnam
Northern Mariana Islands
Norway
Oman
Pacific Islands Trust Territory
Pakistan
Palau
Palestinian Territories
Panama
Panama Canal Zone
Papua New Guinea
Paraguay
People's Democratic Republic of Yemen
Peru
Philippines
Pitcairn Islands
Poland
Portugal
Puerto Rico
Qatar
Romania
Russia
Rwanda
Réunion
Saint Barthélemy
Saint Helena
Saint Kitts and Nevis
Saint Lucia
Saint Martin
Saint Pierre and Miquelon
Saint Vincent and the Grenadines
Samoa
San Marino
Saudi Arabia
Senegal
Serbia
Serbia and Montenegro
Seychelles
Sierra Leone
Singapore
Slovakia
Slovenia
Solomon Islands
Somalia
South Africa
South Georgia and the South Sandwich Islands
South Korea
Spain
Sri Lanka
Sudan
Suriname
Svalbard and Jan Mayen
Swaziland
Sweden
Switzerland
Syria
São Tomé and Príncipe
Taiwan
Tajikistan
Tanzania
Thailand
Timor-Leste
Togo
Tokelau
Tonga
Trinidad and Tobago
Tunisia
Turkey
Turkmenistan
Turks and Caicos Islands
Tuvalu
U.S. Minor Outlying Islands
U.S. Miscellaneous Pacific Islands
U.S. Virgin Islands
Uganda
Ukraine
Union of Soviet Socialist Republics
United Arab Emirates
United Kingdom
United States
Unknown or Invalid Region
Uruguay
Uzbekistan
Vanuatu
Vatican City
Venezuela
Vietnam
Wake Island
Wallis and Futuna
Western Sahara
Yemen
Zambia
Zimbabwe
Åland Islands"
    )

    SelectField.create(
      title: 'Veteran?',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Yes
No"
    )

    SelectField.create(
      title: 'Office location',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "NA
EU
CN
JP"
    )

    SelectField.create(
      title: 'Chapter',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      field_definer: enterprise,
      options_text: "Atlanta
Boston
Montreal
New York
Paris
Washington"
    )

    NumericField.create(
      title: 'Seniority (in years)',
      saml_attribute: '',
      gamification_value: 10,
      show_on_vcard: true,
      match_exclude: false,
      match_polarity: true,
      match_weight: 0.2,
      min: 0,
      max: 40,
      field_definer: enterprise
    )
  end
  spinner.success("[DONE]")
end