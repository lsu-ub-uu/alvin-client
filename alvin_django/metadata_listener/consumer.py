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

def handle_message(payload: dict) -> None:
    from . import services
    services.handle_metadata_change(payload)

def on_message(channel: BlockingChannel, method, properties, body: bytes) -> None:
    try:
        payload = json.loads(body.decode("utf-8"))
    except Exception:
        logger.exception("Could not parse JSON from message")
        channel.basic_ack(delivery_tag=method.delivery_tag)
        return

    try:
        handle_message(payload)
        channel.basic_ack(delivery_tag=method.delivery_tag)
    except Exception:
        logger.exception("Error while handling message.")
        channel.basic_ack(delivery_tag=method.delivery_tag)

def start_consumer() -> None:
    queue_name = settings.RABBITMQ["QUEUE"]
    
    while True:
        try:
            connection = get_connection()
            channel = connection.channel()

            channel.queue_declare(queue=queue_name, durable=True)
            channel.basic_qos(prefetch_count=1)

            channel.basic_consume(
                queue=queue_name,
                on_message_callback=on_message,
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