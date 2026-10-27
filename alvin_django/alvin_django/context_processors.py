from django.utils.translation import gettext_lazy as _

def search_types(request):
    return {
        "search_types": [
            ("alvinRecord", _("Post"), "../alvin_viewer/_icons/details.svg"),
            ("person", _("Person"), "../alvin_viewer/_icons/person.svg"),
            ("organisation", _("Organisation"), "../alvin_viewer/_icons/organisation.svg"),
            ("place", _("Plats"), "../alvin_viewer/_icons/place.svg"),
            ("work", _("Verk"), "../alvin_viewer/_icons/work.svg"),
        ]
    }
