from dataclasses import dataclass, asdict
from typing import Optional
from django.http import QueryDict


@dataclass
class SearchParams:
    searchType: str = 'alvinRecord'
    query: str = '**'
    person: str = ''
    organisation: str = ''
    place: str = ''
    work: str = ''
    location: str = ''
    type: str = ''
    production: str = ''
    genre: str = ''
    subject: str = ''
    language: str = ''
    country: str = ''
    historical: str = ''
    technique: str = ''
    material: str = ''
    right: str = ''
    form: str = ''
    title: str = ''
    name: str = ''
    year: str = ''
    subcollection: str = ''
    occupation: str = ''
    gender: str = ''
    family: str = ''
    identifier: str = ''
    shelfmark: str = ''
    publication: str = ''
    role: str = ''
    collection: str = ''
    digital: str = ''
    id: str = ''

    @classmethod
    def from_querydict(cls, get_params: QueryDict) -> "SearchParams":
        kwargs = {}
        for field_name in cls.__dataclass_fields__:
            val = get_params.get(field_name, '').strip()
            if val:
                kwargs[field_name] = val
        
        if not kwargs.get('query'):
            kwargs['query'] = '**'
        if not kwargs.get('searchType'):
            kwargs['searchType'] = 'alvinRecord'
            
        return cls(**kwargs)

    def to_context_dict(self) -> dict:
        """For easy unpacking of filter variables in the Django context."""
        return asdict(self)
