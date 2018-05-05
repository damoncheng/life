from __future__ import unicode_literals
from django.db import models

class Backends(models.Model):
    backend_class = models.CharField(max_length=1024, help_text="the backend of load app")
    update_time = models.DateTimeField(auto_now=True, help_text="the updatetime of update backend")
