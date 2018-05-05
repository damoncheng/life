# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import re
import traceback
import json
from xlwt import *
from django.shortcuts import render,HttpResponse
from work.management.commands.source.list import getText
from xml.dom.minidom import parse,parseString

from work.models import Grade,Teacher,Course

# Create your views here.
def home(request):
    grade_id = request.GET.get("grade_id", "")
    teacher_id = request.GET.get("teacher_id", "")
    grades = Grade.objects.all()
    if not grade_id and grades:
        grade_id = grades[0].number

    if grade_id:
        teachers = Teacher.objects.select_related("grade").filter(grade__number=grade_id)
    return render(request, "work_home.html", locals())

def teacher_course(request):
    ret = {}
    ret["result"] = 0
    ret["data"] = ""
    ret["msg"] = ""
    try:

        grade_number = request.GET.get("grade")
        teacher_number = request.GET.get("teacher")

        print "#---grade_number", grade_number
        print "#---teacher_number", teacher_number

        courses = Course.objects.filter(grade_number=grade_number, teacher_number=teacher_number).order_by("-create_time")

        if courses:
            ret["data"] = courses[0].content_table
        else:
            ret["data"] = u"未匹配到教师课程表" 

    except:
        traceback.print_exc()
        ret["result"] = 2
        ret["msg"] = u"获取教师课表异常"
        
    
    print ret
    return HttpResponse(json.dumps(ret))

def parse_teacher_table(teacher_course):        
    teacher_course_dict = {}
    teacher_course_dict["name"] = teacher_course.teacher.name
    teacher_course_dict["courses"] = []
    field_type_list = []

    content_table = teacher_course.content_table
    print "#--------origin content_table start----------#"
    print [content_table]
    print "#--------origin content_table end----------#"

    #clear all css of table, tr, td
    content_table = re.sub("<table.*?>", "<table>" ,content_table, flags=re.I)
    content_table = re.sub("<tr.*?>", "<tr>" ,content_table , flags=re.I)
    content_table = re.sub("<td.*?>", "<td>" ,content_table, flags=re.I)
    content_table = re.sub("&ensp;", " " ,content_table)
    content_table = re.sub("<br/?>", "" ,content_table)
    content_table = re.sub(r'([^<])/([^>])', r"\1;\2" ,content_table)

    print [teacher_course.content_table]

    m = re.match("^.*(<table.*/table>).*(<table.*/table>).*(<table.*/table>).*(<table.*/table>).*$" , content_table ,flags=(re.S | re.I))
    if m is not None:
        print "#parse_teacher_table----matched %s:" % [teacher_course.teacher.name]
        teacher_college_table = m.group(1)
        teacher_department_table = m.group(2)
        teacher_course_table = m.group(3)
        teacher_remark_table = m.group(4)

        print "#----teahcer_college_table start----#"
        print [teacher_college_table]
        print "#----teahcer_college_table end----#"

        print "#----teahcer_department_table start----#"
        print [teacher_department_table]
        print "#----teahcer_department_table end----#"

        print "#----teahcer_course_table start----#"
        print [teacher_course_table]
        print "#----teahcer_course_table end----#"

        print "#----teahcer_remark_table start----#"
        print [teacher_remark_table]
        print "#----teahcer_remark_table end----#"

        #这儿不再用dom,后续改用match来进行操作取值
        teacher_course_table_trs = re.findall(".*?</tr>" ,teacher_course_table ,flags=(re.S | re.I))
        print "len(teacher_course_table_trs):", len(teacher_course_table_trs)

        tr_count = 0
        for one_teacher_course_table_tr in teacher_course_table_trs:
            one_teacher_course_table_tr_tds = re.findall("<td>.*?</td>" ,
                    one_teacher_course_table_tr ,flags=(re.S | re.I))
            del one_teacher_course_table_tr_tds[0]
            one_dict = {}
            for index,one_teacher_course_table_tr_td in enumerate(one_teacher_course_table_tr_tds):
                one_teacher_course_table_tr_td_match = re.match("^<td>(.*)</td>$", 
                    one_teacher_course_table_tr_td, flags=(re.S | re.I))
                one_teacher_course_table_tr_td_content = one_teacher_course_table_tr_td_match.group(1)
                if tr_count == 0:
                    field_type_list.append(one_teacher_course_table_tr_td_content)
                else:
                    one_dict[field_type_list[index]] = one_teacher_course_table_tr_td_content

            if tr_count > 0:
                teacher_course_dict["courses"].append(one_dict)
            tr_count += 1
                

    print "#----len(teacher_course_dict['courses'])",len(teacher_course_dict["courses"])
    return (field_type_list, teacher_course_dict)

def teacher_excel(request):

    s_font = 'font: height 200;'
    s_font_red = 'font: height 200,color red,bold true;'
    s_font_u = 'font: height 200,underline single;'
    s_font_b = 'font: height 200,bold true;'

    s_align_left = 'alignment: horz left,vert center;'
    s_align_center = 'alignment: horz center,vert center, wrap on;'
    s_align_right = 'alignment: horz right,vert center;'

    s_border = 'borders: left thin, right thin, top thin, bottom thin,top_colour 0x37,bottom_colour 0x37,left_colour 0x37,right_colour 0x37;'
    s_bk_color_blue = 'pattern: pattern solid,fore_color pale_blue;'
    s_bk_color_gray25 = 'pattern: pattern solid,fore_color light_turquoise;'

    cell_style = easyxf(s_font + s_align_center + s_border)
    cell_style_date = easyxf(s_font + s_align_center + s_border, num_format_str='YYYY-MM-DD h:mm:ss')
    cell_style_red = easyxf(s_font_red + s_align_center + s_border)

    grade_id = request.GET.get("grade_id", "")
    teacher_str = request.GET.get("teacher_name", "")
    teacher_name_list = teacher_str.split(";")

    teacher_id_list = []
    teacher_number_list = []
    for one_teacher_name in teacher_name_list:
        m = re.match("^(\d+)\(([^\)]+)\)$", one_teacher_name)
        if m is not None:
            teacher_number_list.append(m.group(1))
            teacher_id_list.append((m.group(1), m.group(2)))

    print "#-----grade_id:",[grade_id]
    print "#-----teacher_str:",[teacher_str]
    print "#-----teacher_name_list:",[teacher_name_list]
    print "#-----teacher_id_list",[teacher_id_list]

    excel_filename = "teacher_course.xls"
    book = Workbook()
    sheet = book.add_sheet("Sheet 1")

    grade = Grade.objects.get(number=grade_id)
    teacher_course_list = []
    teacher_course_list_origin = list(Course.objects.select_related("teacher").filter(grade_number=grade_id, teacher_number__in=teacher_number_list))
    for one_teacher_number in teacher_number_list:
        for one_teacher_course in teacher_course_list_origin:
            if one_teacher_course.teacher_number == one_teacher_number:
                teacher_course_list.append(one_teacher_course)

    print "#-----len(teacher_course_list):", len(teacher_course_list)
    row_count = 0
    sheet.col(0).width = 5000
    no_course_teacher_list = []
    for one_teacher_course in teacher_course_list:
        if not one_teacher_course.content_table:
            no_course_teacher_list.append(one_teacher_course)
        else:
            teacher_course_tuple =  parse_teacher_table(one_teacher_course)
            if row_count == 0:
                row = sheet.row(row_count)
                row.write(0, u"教师姓名", cell_style)
                for index,one_field in enumerate(teacher_course_tuple[0]):
                    sheet.col(index + 1).width = 5000
                    row.write(index + 1, one_field, cell_style)
                row_count = row_count + 1

            start_row = row_count
            for index,one_course in enumerate(teacher_course_tuple[1]["courses"]):
                row = sheet.row(row_count)
                for index,one_field in enumerate(teacher_course_tuple[0]):
                    row.write(index + 1, one_course[one_field], cell_style)
                row_count = row_count + 1
            sheet.write_merge(start_row, row_count - 1, 0, 0, teacher_course_tuple[1]["name"], cell_style)

    for one_teacher_course in no_course_teacher_list:
        row = sheet.row(row_count)
        row.write(0, one_teacher_course.teacher.name, cell_style)
        row.write(1, u"无课程", cell_style)
        row_count = row_count + 1

    disposition = (u'attachment; filename=%s' % excel_filename).encode("gbk")
    response = HttpResponse(content_type='application/vnd.ms-excel')
    response['Content-Disposition'] = disposition
    book.save(response)

    return response

def teach_teacher_excel(request):
    s_font = 'font: height 200;'
    s_font_red = 'font: height 200,color red,bold true;'
    s_font_u = 'font: height 200,underline single;'
    s_font_b = 'font: height 200,bold true;'

    s_align_left = 'alignment: horz left,vert center;'
    s_align_center = 'alignment: horz center,vert center, wrap on;'
    s_align_right = 'alignment: horz right,vert center;'

    s_border = 'borders: left thin, right thin, top thin, bottom thin,top_colour 0x37,bottom_colour 0x37,left_colour 0x37,right_colour 0x37;'
    s_bk_color_blue = 'pattern: pattern solid,fore_color pale_blue;'
    s_bk_color_gray25 = 'pattern: pattern solid,fore_color light_turquoise;'

    cell_style = easyxf(s_font + s_align_center + s_border)
    cell_style_date = easyxf(s_font + s_align_center + s_border, num_format_str='YYYY-MM-DD h:mm:ss')
    cell_style_red = easyxf(s_font_red + s_align_center + s_border)

    grade_id = request.GET.get("grade_id", "")
    teacher_str = request.GET.get("teacher_name", "")
    teacher_name_list = teacher_str.split(";")

    teacher_id_list = []
    teacher_number_list = []
    for one_teacher_name in teacher_name_list:
        m = re.match("^(\d+)\(([^\)]+)\)$", one_teacher_name)
        if m is not None:
            teacher_number_list.append(m.group(1))
            teacher_id_list.append((m.group(1), m.group(2)))


    print "#-----grade_id:",[grade_id]
    print "#-----teacher_str:",[teacher_str]
    print "#-----teacher_name_list:",[teacher_name_list]
    print "#-----teacher_id_list",[teacher_id_list]

    excel_filename = "teacher_course.xls"
    book = Workbook()
    sheet = book.add_sheet("Sheet 1")

    grade = Grade.objects.get(number=grade_id)
    teacher_course_list = []
    teacher_course_list_origin = list(Course.objects.select_related("teacher").filter(grade_number=grade_id, teacher_number__in=teacher_number_list))
    for one_teacher_number in teacher_number_list:
        for one_teacher_course in teacher_course_list_origin:
            if one_teacher_course.teacher_number == one_teacher_number:
                teacher_course_list.append(one_teacher_course)

    filtered_field = [u"课程", u"上课班级"]

    print "#-----len(teacher_course_list):", len(teacher_course_list)
    print "#-------teach_teacher_excel--------#"
    teacher_index = 0
    row_count = 0
    no_course_teacher_list = []
    for one_teacher_course in teacher_course_list:
        if not one_teacher_course.content_table:
            no_course_teacher_list.append(one_teacher_course)
        else:
            teacher_course_tuple =  parse_teacher_table(one_teacher_course)
            if row_count == 0:
                row = sheet.row(row_count)
                offset_col = 0
                sheet.col(offset_col).width = 5000
                row.write(offset_col, u"序列", cell_style)
                offset_col = offset_col + 1
                sheet.col(offset_col).width = 5000
                row.write(offset_col, u"教师姓名", cell_style)
                offset_col = offset_col + 1
                for index,one_field in enumerate(filtered_field):
                    sheet.col(offset_col).width = 5000
                    row.write(offset_col, one_field, cell_style)
                    offset_col = offset_col + 1
                sheet.col(offset_col).width = 5000
                row.write(offset_col, u"授课时间", cell_style)
                offset_col = offset_col + 1
                sheet.col(offset_col).width = 5000
                row.write(offset_col, u"教案类型", cell_style)
                offset_col = offset_col + 1
                sheet.col(offset_col).width = 5000
                row.write(offset_col, u"备注", cell_style)
                row_count = row_count + 1

            start_row = row_count
            for index,one_course in enumerate(teacher_course_tuple[1]["courses"]):
                row = sheet.row(row_count)
                offset_col = 0
                offset_col = offset_col + 1
                offset_col = offset_col + 1
                for index,one_field in enumerate(filtered_field):
                    row.write(offset_col, one_course[one_field], cell_style)
                    offset_col = offset_col + 1
                offset_col = offset_col + 1
                row.write(offset_col, u"手写", cell_style)
                offset_col = offset_col + 1
                row_count = row_count + 1
            sheet.write_merge(start_row, row_count - 1, 0, 0, teacher_index + 1, cell_style)
            sheet.write_merge(start_row, row_count - 1, 1, 1, teacher_course_tuple[1]["name"], cell_style)
            teacher_index = teacher_index + 1

    if row_count > 0:
        sheet.write_merge(1, row_count - 1, 2 + len(filtered_field),  2 + len(filtered_field) , 
                grade.name, cell_style)

    disposition = (u'attachment; filename=%s' % excel_filename).encode("gbk")
    response = HttpResponse(content_type='application/vnd.ms-excel')
    response['Content-Disposition'] = disposition
    book.save(response)

    return response

