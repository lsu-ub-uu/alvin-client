person = {
    "AUTH_NAME": {
        "family_name": "./name/namePart[@type='family']",
        "given_name": "./name/namePart[@type='given']",
        "numeration": "./name/namePart[@type='numeration']",
        "terms_of_address": "./name/namePart[@type='termsOfAddress']",
        "orientation_code": "./name/orientationCode",
        "variant_type": "variantType"
    },
    "VARIANT": {
        "language": "./@lang",
        "family_name": "./name/namePart[@type='family']",
        "given_name": "./name/namePart[@type='given']",
        "numeration": "./name/namePart[@type='numeration']",
        "terms_of_address": "./name/namePart[@type='termsOfAddress']",
        "orientation_code": "./name/orientationCode",
        "variant_type": "variantType"
    }
}

place = {
    "AUTH_NAME": {
        "geographic": "./geographic",
        "orientation_code": "./orientationCode"
    },
    "VARIANT": {
        "language": "./@lang",
        "geographic": "./geographic",
        "orientation_code": "./orientationCode"
    }
}

organisation = {
    "AUTH_NAME": {
        "corporate_name": "./name/namePart[@type='corporateName']",
        "subordinate_name": "./name/namePart[@type='subordinate']",
        "terms_of_address": "./name/namePart[@type='termsOfAddress']",
        "orientation_code": "./name/orientationCode",
        "variant_type": "variantType"
    },
    "VARIANT": {
        "language": "./@lang",
        "corporate_name": "./name/namePart[@type='corporateName']",
        "subordinate_name": "./name/namePart[@type='subordinate']",
        "terms_of_address": "./name/namePart[@type='termsOfAddress']",
        "orientation_code": "./name/orientationCode",
        "variant_type": "./@variantType"
    }
}