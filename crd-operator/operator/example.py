import kopf
import logging

@kopf.on.create('kopfexamples')
def create_fn(spec, **kwargs):
    logging.info(f"create_fn(): spec={spec}")
    return {'message': 'hello world'}  # will be the new status
