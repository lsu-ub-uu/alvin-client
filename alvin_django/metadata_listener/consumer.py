import json
import logging
import time

import pika
from django.conf import settings
from pika.adapters.blocking_connection import BlockingChannel

logger = logging.getLogger(__name__)

def get_connection() -> pika.BlockingConnection:
    params = pika.ConnectionParameters(
        host=settings.RABBITMQ["HOST"],
        port=settings.RABBITMQ["PORT"],
        virtual_host=settings.RABBITMQ["VHOST"],
        heartbeat=600,
        blocked_connection_timeout=300,
    )
    return pika.BlockingConnection(params)

def handle_message() -> None:
    from . import services
    services.handle_metadata_change(payload)

def on_message(channel: BlockingChannel, method, properties, body: bytes) -> None:
    headers = properties.headers
    if headers and "type" in headers:
        record_type = properties.headers["type"]
        #record_id = properties.headers["id"]
        #action = properties.headers["action"] # CREATE, UPDATE, DELETE

    if record_type in ["metadata", "text"]:
        try:
            handle_message()
        except Exception:
            logger.exception("Error while handling message.")

def start_consumer() -> None:
    exchange_name = settings.RABBITMQ["EXCHANGE"]
    
    while True:
        try:
            connection = get_connection()
            channel = connection.channel()

            #channel.exchange_declare(exchange=exchange_name, exchange_type="fanout", durable=True, passive=True)
            channel.queue_declare(queue="alvinclient_reload", exclusive=True)
            channel.queue_bind(queue="alvinclient_reload", exchange=exchange_name)
            channel.basic_qos(prefetch_count=1)

            channel.basic_consume(
                queue="alvinclient_reload",
                on_message_callback=on_message,
                auto_ack=True
            )

            logger.info("RabbitMQ-consumer started, waiting for message...")
            channel.start_consuming()

        except pika.exceptions.AMQPConnectionError:
            logger.exception("Lost connection to RabbitMQ, trying again in 5 sec…")
            time.sleep(5)
        except KeyboardInterrupt:
            logger.info("Consumer interupted with Ctrl+C")
            try:
                if connection and connection.is_open:
                    connection.close()
            except Exception:
                pass
            break
        except Exception:
            logger.exception("Unrecognized error, reconnecting in 5 sec…")
            time.sleep(5)