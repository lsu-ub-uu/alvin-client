from lxml import etree
from .common import _get_label, _get_value, _norm_rt, _xp, agents, compact, dates, decorated_text, decorated_list, decorated_list_item, electronic_locators, first, origin_places, titles
from .records import AlvinWork
from ..xmlutils.nodes import text, attr, element, elements
from .cleaner import clean_empty

rt = _norm_rt("alvin-work")

def extract(root: etree._Element) -> AlvinWork:

    return AlvinWork(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type="alvin-work",
        source_xml = text(root, "actionLinks/read/url"),
        created = decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        last_updated = decorated_text(root, _xp(rt, "recordInfo/updated/tsUpdated[last()]")),
        form_of_work = decorated_list_item(root, _xp(rt, "formOfWork")),
        label = _get_label(element(root, "data/work")),
        main_title = titles(root, _xp(rt, "title")),
        variant_titles = titles(root, _xp(rt, "variantTitle")),
        origin_date = dates(root, _xp(rt, "originDate"), "start", "end"),
        origin_places = origin_places(root, _xp(rt, "originPlace")),
        date_other = [dates(date, ".", "start", "end") for date in elements(root, _xp(rt, "dateOther"))],
        incipit = decorated_text(root, _xp(rt, "incipit")),
        literature = decorated_text(root, _xp(rt, "listBibl")),
        note = decorated_text(root, _xp(rt, "note")),
        agents = agents(root, _xp(rt, "agent")),
        longitude = decorated_text(root, _xp(rt, "point/longitude")),
        latitude = decorated_text(root, _xp(rt, "point/latitude")),
        music_key = decorated_list(root, _xp(rt, "musicKey")),
        music_key_other = decorated_text(root, _xp(rt, "musicKeyOther")),
        music_medium = decorated_list(root, _xp(rt, "musicMedium")),
        music_medium_other = decorated_text(root, _xp(rt, "musicMediumOther")),
        genre_form = decorated_list(root, _xp(rt, "genreForm")),
        serial_number = decorated_text(root, _xp(rt, "numericDesignationOfMusicalWork/musicSerialNumber")),
        opus_number = decorated_text(root, _xp(rt, "numericDesignationOfMusicalWork/musicOpusNumber")),
        thematic_number = decorated_text(root, _xp(rt, "numericDesignationOfMusicalWork/musicThematicNumber")),
    )