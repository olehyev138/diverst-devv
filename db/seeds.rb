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

disabilities_field = CheckboxField.create(
  title: "Disabilities",
  saml_attribute: "",
  gamification_value: 10,
  show_on_vcard: true,
  match_exclude: false,
  match_polarity: true,
  match_weight: 0.2,
  enterprise: enterprise
)

disabilities_field.options.create([{
  title: "Deaf"
}, {
  title: "Blind"
}, {
  title: "Crippled"
}, {
  title: "Wheelchair"
}])



admin = Admin.create(
  enterprise: enterprise,
  first_name: "Francis",
  last_name: "Marineau",
  email: "frank.marineau@gmail.com",
  password: "password",
  password_confirmation: "password"
)