from django.utils.translation import gettext_lazy as _

def search_types(request):
    return {
        "search_types": [
            ("alvinRecord", _("Post"), "_icons/details.svg"),
            ("person", _("Person"), "_icons/person.svg"),
            ("organisation", _("Organisation"), "_icons/organisation.svg"),
            ("place", _("Plats"), "_icons/place.svg"),
            ("work", _("Verk"), "_icons/work.svg"),
        ]
    }
