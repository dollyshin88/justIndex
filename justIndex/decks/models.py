from django.db import models
from django.contrib.auth.models import User
# Create your models here.


class Deck(models.Model):
    name = models.CharField(max_length=225)
    created = models.DateField(auto_now_add=True)
    last_reviewed = models.DateTimeField(auto_now=True)
    tags = models.ManyToManyField("Tag", null=True, blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)

class Tag(models.Model):
    name = models.CharField(max_length=225)
    user = models.ForeignKey(User, on_delete=models.CASCADE, blank=True)
