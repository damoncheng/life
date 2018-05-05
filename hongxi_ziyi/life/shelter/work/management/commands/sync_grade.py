#coding: utf-8

import os
import sys
import traceback

from work.models import Grade

from django.core.management.base import BaseCommand,CommandError
from optparse import make_option
from work.management.commands.source.list import getGrade,print_msg

class Command(BaseCommand):
    help = "obtain teacher info"

    def handle(self, *args, **options):
        os.chdir(os.path.join(os.path.dirname(__file__), "source"))
        ret = getGrade()
        
        if ret["result"] == 0:
            grade_id_list = ret["data"][0]
            grade_name_list = ret["data"][1]
            saved_grade_id_list = list(Grade.objects.filter(number__in=grade_id_list).values_list("number", flat=True))
            saved_count = 0

            for index,id in enumerate(grade_id_list):
                if id not in saved_grade_id_list:
                    one_grade = Grade()
                    one_grade.number = grade_id_list[index]
                    one_grade.name = grade_name_list[index]
                    one_grade.save()
                    saved_count += 1
            print_msg("success - %s - %s" % (str(len(grade_id_list)), str(saved_count)))
        else:
            print_msg("fail")
        return 
