# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models

# Create your models here.
class Grade(models.Model):
    number = models.CharField(max_length=1024, help_text="grade ID")
    name = models.CharField(max_length=1024, help_text="grade name")
    create_time = models.DateTimeField(auto_now=True,  help_text="the time of update")

class Teacher(models.Model):
    grade = models.ForeignKey(Grade)
    number = models.CharField(max_length=1024, help_text="teacher ID")
    name = models.CharField(max_length=1024, help_text="teacher name")
    create_time = models.DateTimeField(auto_now=True,  help_text="the time of update")

class MonthTeacher(models.Model):
    teacher = models.ForeignKey(Teacher)
    create_time = models.DateTimeField(auto_now=True,  help_text="the time of wait teacher this month")

class Course(models.Model):
    teacher = models.ForeignKey(Teacher)
    teacher_number = models.CharField(max_length=1024, help_text="teacher ID")
    grade_number = models.CharField(max_length=1024, help_text="grade ID")
    content_table = models.TextField(default="", help_text="the tag of show")
    create_time = models.DateTimeField(auto_now=True,  help_text="the time of update")


