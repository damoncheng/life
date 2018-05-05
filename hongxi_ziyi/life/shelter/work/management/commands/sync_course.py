#coding: utf-8

import threading
import os
import sys
import traceback

from work.models import Grade,Teacher,Course

from django.core.management.base import BaseCommand,CommandError
from optparse import make_option
from work.management.commands.source.list import getCourse,print_msg

class boot_thread(threading.Thread):
    def __init__(self, command, grade):
        threading.Thread.__init__(self)
        self.command = command
        self.grade = grade

    def run(self):
        LIMIT = 10
        if not os.path.exists(os.path.join(os.path.dirname(__file__), "source", self.grade.number)):
           os.mkdir(os.path.join(os.path.dirname(__file__), "source", self.grade.number))

        course_teacher_list = list(Course.objects.filter(grade_number=self.grade.number).values_list("teacher_number", flat=True))
        teachers = list(Teacher.objects.select_related("grade").filter(grade=self.grade).exclude(number__in=course_teacher_list))
        print_msg("#Sync---Grade:%s---Teachers:%s" % (self.grade.number,str(len(teachers))))

        for one_teacher in teachers:
            current_limit = 0
            flag = True
            while(current_limit <= 10 and flag):
                ret = getCourse(one_teacher.grade.number, one_teacher.number, subdir=one_teacher.grade.number)
                if ret["result"] == 0:
                    #print_msg(ret)
                    one_course = Course()
                    one_course.teacher = one_teacher
                    one_course.grade_number = one_teacher.grade.number
                    one_course.teacher_number = one_teacher.number
                    one_course.content_table = ret["data"]
                    one_course.save()
                    flag = False
                else:
                    print_msg(str(ret["result"]))
                    print_msg(ret["msg"])
                    current_limit += 1


class Command(BaseCommand):
    help = "obtain course info"

    def handle(self, *args, **options):

        os.chdir(os.path.join(os.path.dirname(__file__), "source"))
        grades = Grade.objects.all()
        threads = []
        for one_grade in grades:
            one_boot_thread = boot_thread(self, one_grade)
            one_boot_thread.start()
            threads.append(one_boot_thread)

        for t in threads:
            t.join()

        return 
