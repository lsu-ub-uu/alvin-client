from django.core.management.base import BaseCommand
from metadata_listener.consumer import start_consumer

class Command(BaseCommand):
    help = "Listens to metadata changes from RabbitMQ"

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS("Staring metadata consumer..."))
        start_consumer()
        self.stdout.write(self.style.WARNING("Metadata consumer stopped."))