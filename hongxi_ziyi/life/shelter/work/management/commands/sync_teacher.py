#coding: utf-8

import os
import sys
import traceback

from work.models import Grade,Teacher

from django.core.management.base import BaseCommand,CommandError
from optparse import make_option
from work.management.commands.source.list import getTeacher,print_msg

class Command(BaseCommand):
    help = "obtain teacher info"

    def handle(self, *args, **options):
        os.chdir(os.path.join(os.path.dirname(__file__), "source"))
        grades = Grade.objects.all()

        for one_grade in grades:
            ret = getTeacher(one_grade.number)
            if ret["result"] == 0:
                teacher_id_list = ret["data"][0]
                teacher_name_list = ret["data"][1]
                saved_count = 0

                saved_teacher_id_list = list(Teacher.objects.filter(grade=one_grade, number__in=teacher_id_list).values_list("number", flat=True))
                for index,id in enumerate(teacher_id_list):
                    if id not in saved_teacher_id_list:
                        one_teacher = Teacher()
                        one_teacher.grade = one_grade
                        one_teacher.number = teacher_id_list[index]
                        one_teacher.name = teacher_name_list[index]
                        one_teacher.save()
                        saved_count += 1
                print_msg("%s success - %s - %s" % (one_grade.number, str(len(teacher_id_list)), str(saved_count)))
            else:
                print_msg("%s fail" % one_grade.number)
        return 
