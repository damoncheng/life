#coding:utf-8
#!/usr/bin/python

try:
    import Image
except ImportError:
    from PIL import Image,ImageEnhance,ImageDraw
from pytesseract import *
from xml.dom.minidom import parse, parseString

pytesseract.tesseract_cmd = '/usr/bin/tesseract'

import os
import sys
import traceback
import httplib
import urllib2
import re
from urllib import urlencode


R,G,B = 0, 1, 2

threshold = 200   
table = []    
for i in range(256):    
    if i < threshold:    
        table.append(0)    
    else:    
        table.append(1) 

def print_msg(msg):
    #print msg
    sys.stdout.write(msg)
    sys.stdout.write('\n')

def saveFile(content, file_name):
    with open(file_name, "w") as f:
        f.write(content)

def saveFile_b(content, file_name):
    with open(file_name, "wb") as f:
        f.write(content)

def getPixel(image, x, y, N):
    pixel = image.getpixel((x,y))
    
    if pixel == 255:
        return None

    nearDots = 0
    if pixel == image.getpixel((x - 1, y - 1)):
        nearDots += 1
    
    if pixel == image.getpixel((x - 1, y)):
        nearDots += 1

    if pixel == image.getpixel((x - 1, y + 1)):
        nearDots += 1

    if pixel == image.getpixel((x, y + 1)):
        nearDots += 1

    if pixel == image.getpixel((x, y - 1)):
        nearDots += 1

    if pixel == image.getpixel((x + 1, y - 1)):
        nearDots += 1

    if pixel == image.getpixel((x + 1, y)):
        nearDots += 1

    if pixel == image.getpixel((x + 1, y + 1)):
        nearDots += 1

    if nearDots < N:
        return 255

    return None

def clearNoise(image, N, Z):
    draw = ImageDraw.Draw(image)
    for i in xrange(0,Z):
        for x in xrange(1, image.size[0] - 1):
            for y in xrange(1, image.size[1] - 1):
                color = getPixel(image, x, y, N)
                if color != None:
                    draw.point((x,y), color)

def getValidcodeText(file_name, subdir=""):
    original_img = Image.open(os.path.join(subdir, file_name))
    gray_img = original_img.convert('L')
    gray_img.save(os.path.join(subdir, "gray_" + file_name))

    binary_img = gray_img.point(table,'1')
    binary_img.save(os.path.join(subdir, "binary_" + file_name))

    clearNoise(binary_img, 3, 5)
    binary_img.save(os.path.join(subdir, "denoising_binary_" + file_name))
    img = binary_img

    #data = img.getdata()
    #w,h = img.size
    #print len(data)
    #print data[0]
    #print "w:",w
    #print "h:",h

    return image_to_string(img, config="validcode")


def getText(nodelist):
    rc = []
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            rc.append(node.data)
    return ''.join(rc)

def getGrade():
    ret = {}
    ret["result"] = 0
    ret["msg"] = ""
    ret["data"] = []

    try:
        url = "http://jwc.zync.edu.cn/ZNPK/TeacherKBFB.aspx"
        print_msg(url)

        fd = urllib2.urlopen(url, timeout=10)
        content = fd.read()
        #saveFile(content, "test.txt")
        content = content.decode("gbk").encode("utf-8")

        m = re.match(".*(<select.*Sel.XNXQ.*?/select>).*", content, flags=re.S)
        #print m.group(1)
        content_grade = m.group(1)
        content_grade = re.sub("value=(\w+)", 'value="\\1"', content_grade)
        dom = parseString(content_grade)
        node_list = dom.getElementsByTagName("option")

        grade_id_list = []
        grade_name_list = []
        grade_list = []
        for node in node_list:
            #print node.getAttribute("value"),"-",getText(node.childNodes)
            grade_id_list.append(node.getAttribute("value"))
            grade_name_list.append(getText(node.childNodes))

        grade_list = [grade_id_list, grade_name_list]
        ret["data"] = grade_list

    except:
        ret["result"] = 2
        ret["msg"] = traceback.format_exc()
        
    return ret

    
def getValidcode(session_header, subdir=""):
    '''
    validcode_url = "http://jwc.zync.edu.cn/sys/ValidateCode.aspx"
    fd = urllib2.urlopen(validcode_url, timeout=10)
    content_img = fd.read()
    '''

    print_msg("#-------getValidcode-------#")

    headers = {
        "Accept" : "image/webp,image/*,*/*;q=0.8",
        "User-Agent" : "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",
        "Cache-Control": "max-age=0",
        "Referer" : "http://jwc.zync.edu.cn/ZNPK/TeacherKBFB.aspx",
        "Cookie" : session_header,
    }

    conn = httplib.HTTPConnection("jwc.zync.edu.cn", timeout=10)
    conn.request("GET", "/sys/ValidateCode.aspx", headers=headers)
    response = conn.getresponse()
    print_msg(str(response.status) + "," + str(response.reason))
    content_img = response.read()

    saveFile_b(content_img, os.path.join(subdir, "validcode.jpg"))

    file_name = "validcode.jpg"
    validcode_text = getValidcodeText(file_name, subdir)
    return validcode_text

def getTeacher(grade_id):

    ret = {}
    ret["result"] = 0
    ret["msg"] = ""
    ret["data"] = []

    try:
        url = "http://jwc.zync.edu.cn/ZNPK/Private/List_JS.aspx?xnxq=%s&js=" % grade_id
        print_msg(url)

        fd = urllib2.urlopen(url, timeout=10)
        content = fd.read()

        m = re.match(".*(<select.*/select>).*", content)
        content = m.group(1)
        content = content.replace("name=Sel_JS", "")
        content = re.sub("value=(\w+)", 'value="\\1"', content)
        content = content.decode("gbk").encode("utf-8")
        #print m.group(1)

        dom = parseString(content)
        node_list = dom.getElementsByTagName("option")

        teacher_id_list = []
        teacher_name_list = []
        teacher_list = []
        for node in node_list:
            #print node.getAttribute("value"),"-",getText(node.childNodes)
            id = node.getAttribute("value")
            name = getText(node.childNodes)
            if name:
                teacher_id_list.append(id)
                teacher_name_list.append(name)

        teacher_list = [teacher_id_list, teacher_name_list]
        ret["data"] = teacher_list
    except:
        ret["result"] = 2
        ret["msg"] = traceback.format_exc()

    return ret

def getCourse(grade_id, teacher_id, subdir="", type=2):

	ret = {}
	ret["result"] = 0

	try:
		#url = "http://jwc.zync.edu.cn/ZNPK/TeacherKBFB_rpt.aspx"

		print_msg("#------getCourse session_header-------#")
		headers = {
			"Content-Type" : "text/html;charset=gb2312",        
			"Accept" : "text/html",
			"User-Agent" : "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",
			"Cache-Control": "max-age=0",
		}

		conn = httplib.HTTPConnection("jwc.zync.edu.cn", timeout=10)
		conn.request("GET", "/ZNPK/TeacherKBFB.aspx", headers=headers)
		response = conn.getresponse()
		print_msg(str(response.status) + "," + str(response.reason))
		session_header = response.getheader("Set-Cookie")
		session_header = session_header.split(";")[0]

		params = {}
		params["Sel_XNXQ"] = grade_id
		params["Sel_JS"] = teacher_id
		params["type"] = type
		validcode = getValidcode(session_header, subdir)
		print_msg("#---------validcode:" + "," + validcode)
		params["txt_yzm"] = validcode


		print_msg("#------getTeacherExcel get teacher class table-------#")
		headers = {
			"Content-Type" : "application/x-www-form-urlencoded",        
			"Accept" : "text/html",
			"User-Agent" : "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",
			"Cache-Control": "max-age=0",
			"Referer" : "http://jwc.zync.edu.cn/ZNPK/TeacherKBFB.aspx",
			"Cookie" : session_header,
		}

		conn = httplib.HTTPConnection("jwc.zync.edu.cn", timeout=10)
		conn.request("POST", "/ZNPK/TeacherKBFB_rpt.aspx", urlencode(params), headers)
		response = conn.getresponse()
		print_msg(str(response.status) + "," + str(response.reason))
		content = response.read()
		saveFile(content, "class_table.html")

		m = re.match(".*(<table.*/table>.*<table.*/table>).*", content, flags=re.S)
		o = re.match(".*(<table.*/table>).*", content, flags=re.S)
                s = re.match("^<script.*alert.*/script>.*", content, flags=re.S)
		if m is not None:
			content = m.group(1)
			ret["data"] = content.decode("gbk")
                        print_msg(str(teacher_id) + "-" + ret["data"].encode("utf-8"))
                elif s is None and o is not None:
                        content = ""
                        ret["data"] = content
                        print_msg(str(teacher_id) + "-" + ret["data"].encode("utf-8"))
		else:
			ret["result"] = 1
			ret["msg"] = "obtain validcode fail"
                        print_msg(str(teacher_id) + "-" + ret["msg"])

	except:
		ret["result"] = 2
		ret["msg"] = traceback.format_exc()

	return ret


if __name__ == '__main__':
    #print getTeacher(20170)
    #print getGrade()

    print getCourse(20170, 2017017)
