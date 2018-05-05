#coding:utf-8
import traceback
import os
import hashlib
import json
import shutil

from django.shortcuts import render
from django.http import HttpResponse,HttpRequest,HttpResponseRedirect

from travel.models import Photo,User,Photo_Sendword,Photo_Img_Tag
from shelter import settings

from django.urls import reverse

import os
import copy

def login(request):
    
    s_username = request.session.get("username", "")
    if s_username:
        return HttpResponseRedirect("home")

    username = request.POST.get("username", "")
    password = request.POST.get("password", "")
    if username != "" and password != "":
        m = hashlib.md5()
        m.update(password)
        user_count = len(User.objects.filter(name=username, password=m.hexdigest()))
        print "user_count=",user_count
        if user_count == 1:
            request.session["username"] = username
            request.session.set_expiry(0)
            return HttpResponseRedirect(reverse("travel_home"))
    return render(request, "login.html", locals())

def login_out(request):
    print "#------login_out--------#"
    if "username" in request.session and request.session["username"]:
        del request.session["username"]

    return HttpResponseRedirect(reverse("travel_home"))

def login_required(func):
    def _login_required(obj):

        s_username = obj.involve.request.session.get("username","")
        if not s_username:
            return HttpResponseRedirect(reverse("travel_login"))

        return func(obj)

    return _login_required


def admin(request):
    operator = request.GET.get("operator","")

    if not operator:
        operator = "photo"
   
    if operator == "photo":
        max_year = 0
        year_list = []
        photo_dict = {}
        photos = Photo.objects.all()
        for one_photo in photos:
            if one_photo.year not in photo_dict:
                photo_dict[one_photo.year] = {}

            if one_photo.id not in photo_dict[one_photo.year]:
                photo_dict[one_photo.year][one_photo.id] = {}
        
            photo_dict[one_photo.year][one_photo.id]["area"] = one_photo.area
            photo_dict[one_photo.year][one_photo.id]["city"] = one_photo.city
            photo_dict[one_photo.year][one_photo.id]["tag"] = one_photo.tag

            if one_photo.year not in year_list:
                year_list.append(one_photo.year)

            print "max_year:",max_year
            if max_year < one_photo.year:
                max_year = one_photo.year

        year_list.sort(reverse=True)
        year = request.GET.get("image_year", "")
        if not year:
            year = max_year
        year = int(year) if year else ""

        print "year:", year
        print "year_list:",year_list

    print "photo_dict:",photo_dict
    print "operator:",operator

    return render(request, "admin.html", locals())

# Create your views here.
def home(request):
    max_year = 0
    photo_dict = {}
    default_photo_dict = {}
    year_list = []
    image_list = []
    image_path_list = []
    image_path_dict = {}

    year = request.GET.get("image_year", "")
    image_area = ""
    image_city = ""
    photo_id = ""
    photos = list(Photo.objects.all().order_by("-create_time"))

    for one_photo in photos:
        if one_photo.year not in photo_dict:
            photo_dict[one_photo.year] = {}

        if one_photo.area not in photo_dict[one_photo.year]:
            photo_dict[one_photo.year][one_photo.area] = {}
            if one_photo.year not in default_photo_dict:
                default_photo_dict[one_photo.year] = {}
                default_photo_dict[one_photo.year]["area"] = one_photo.area

        if one_photo.city not in photo_dict[one_photo.year][one_photo.area]:
            photo_dict[one_photo.year][one_photo.area][one_photo.city] = {}
            if "city" not in default_photo_dict[one_photo.year]:
                default_photo_dict[one_photo.year]["city"] = one_photo.city

        if "tag" not in photo_dict[one_photo.year][one_photo.area][one_photo.city]:
            photo_dict[one_photo.year][one_photo.area][one_photo.city]["tag"] = one_photo.tag

        if one_photo.year not in year_list:
            year_list.append(one_photo.year)

        if max_year < one_photo.year:
            max_year = one_photo.year


    if photos:
        year_list.sort(reverse=True)
        image_path = request.GET.get("image_area_city", "")
        if not year:
            year = max_year
        year = int(year) if year else ""

        if image_path:
            image_area = image_path.split("&&")[0]
            image_city = image_path.split("&&")[1]
        else:
            image_area = default_photo_dict[year]["area"]
            image_city = default_photo_dict[year]["city"]

        selected_photo = Photo.objects.get(year=year, area=image_area, city=image_city)
        photo_id = selected_photo.id
        image_dir = os.path.join(settings.BASE_DIR, "static", "images", str(year), image_area, image_city)
        image_list = os.listdir(image_dir)

        for one_image in image_list:
            one_image_path = os.path.join("images", str(year), image_area, image_city, one_image)
            image_path_list.append(one_image_path)
            if one_image_path not in image_path_dict:
                image_path_dict[one_image_path] = {}
                image_path_dict[one_image_path]["image_file_name"] = one_image
                image_path_dict[one_image_path]["image_name"] = one_image.split(".")[0]

        img_tags = list(Photo_Img_Tag.objects.filter(photo=selected_photo,img_name__in=image_list))
        for one_img_tag in img_tags:
            one_image_path = os.path.join("images", str(year), image_area, image_city, one_img_tag.img_name)
            if one_image_path in image_path_dict:
                image_path_dict[one_image_path]["image_name"] = one_img_tag.tag_name

        psendword_list = list(Photo_Sendword.objects.filter(photo=selected_photo).order_by("-create_time"))
        if not psendword_list:
            psendword = Photo_Sendword()
            psendword.photo = selected_photo
            psendword.word = "here is %s %s" % (image_area ,image_city)
            psendword.save()
        else:
            psendword = psendword_list[0]

        print "image_area:",[image_area]
        print "image_city:",[image_city]

    print "photo_dict:",photo_dict
    print "year:",year
    return render(request, "home.html", locals())


class Involve(object):
    def __init__(self, params = {}, request = None):
        self.params = params
        self.request = request
        self.involve = self

    def get_html(self):
        class_name = self.request.GET.get("class_name", "")
        method_name = self.request.GET.get("method_name", "")

        if class_name == "Involve":
            call_method = getattr(self, method_name)
            return call_method()
        else:
            call_class = globals()[class_name]
            call_class_obj = call_class(self)
            call_method = getattr(call_class_obj, method_name)
            return call_method()


    def get_html_ajax(self):
        pass

    def get_method_(self):
        pass

    def get_home(self):
        return home(self.request)

    @login_required
    def get_admin(self):
        return admin(self.request)

    @login_required
    def get_login_out(self):
        return login_out(self.request)
    

class Administrator(object):

    def __init__(self, involve):
        self.involve = involve

    @login_required
    def update_sendword(self):
        word_id = self.involve.request.POST.get("word_id", "")
        word = self.involve.request.POST.get("word", "")

        try:
            print "word_id:", word_id
            print "word:", [word]

            if word_id == "":
                return ajax_fail("id can not be empty!")

            Photo_Sendword.objects.filter(id=word_id).update(word=word)
        except:
            traceback.print_exc()
            return self.ajax_fail("save photo_sendword fail!")

        return self.ajax_success("save photo_sendword success!")


    @login_required
    def update_photo(self):
        photo_id = self.involve.request.GET.get("photo_id", "")
        photo_year = self.involve.request.GET.get("photo_year", "")
        photo_area = self.involve.request.GET.get("photo_area", "")
        photo_city = self.involve.request.GET.get("photo_city", "")
        photo_tag = self.involve.request.GET.get("photo_tag", "")

        print "photo_id:",photo_id
        print "photo_year:",[photo_year]
        print "photo_area:",[photo_area]
        print "photo_city:",[photo_city]
        print "photo_tag:",[photo_tag]

        if photo_year == "":
           return self.location_fail('year can not be empty!')
        elif photo_area == "":
           return self.location_fail('area can not be empty!')
        elif photo_city == "":
           return self.location_fail('city can not be empty!')


        try:

           photo_exist = Photo.objects.filter(year=photo_year, area=photo_area,city=photo_city).exclude(id=photo_id)
           if photo_exist:
               return location_fail("year:%s area:%s city:%s have been exists!" % (photo_year, photo_area, photo_city))

           #--------------get photo of index--------#
           photo = Photo.objects.get(id=photo_id)
           photo.tag = photo_tag

           ## check if year is exist ##
           year_exist = os.path.exists(os.path.join(settings.BASE_DIR, "static", "images", photo_year))
           if not year_exist:
               os.mkdir(os.path.join(settings.BASE_DIR, "static", "images", photo_year))

           ## check if area is exist ##
           area_exist = os.path.exists(os.path.join(settings.BASE_DIR, "static", "images", photo_year ,photo_area))
           if not area_exist:
               os.mkdir(os.path.join(settings.BASE_DIR,  "static", "images", photo_year, photo_area))

           ## check if city is exist ##
           city_exist = os.path.exists(os.path.join(settings.BASE_DIR, "static", "images", photo_year, photo_area, photo_city))
           if not city_exist:
               os.mkdir(os.path.join(settings.BASE_DIR, "static", "images", photo_year, photo_area, photo_city))

           old_path = os.path.join(settings.BASE_DIR, "static", "images", str(photo.year), photo.area, photo.city) 
           new_path = os.path.join(settings.BASE_DIR, "static", "images", photo_year, photo_area, photo_city)
           print "old_path:",old_path
           print "new_path:",new_path
          
           if new_path != old_path:
               file_list = os.listdir(old_path) 
               for one_file in file_list:
                   shutil.move(
                      os.path.join(old_path, one_file),
                      os.path.join(new_path, one_file)
                   )
               photo.year = photo_year
               photo.area = photo_area
               photo.city = photo_city

           #---------step tree: update database ----------#
           photo.save()

        except:
           traceback.print_exc()
           photo.save()
           return self.location_fail('exception! notice hongxi(ffshelterss@gmail.com)')

        return HttpResponseRedirect(self.involve.request.META["HTTP_REFERER"])

    @login_required
    def del_photo(self):
        photo_id = self.involve.request.GET.get("photo_id", "")

        print "photo_id:", photo_id
        try:
            if photo_id == "":
                return self.location_fail("photo_id can not be empty!")
            Photo.objects.filter(id=photo_id).delete()
        except:
            traceback.print_exc()
            return self.location_fail("delete photo failed")

        return HttpResponseRedirect(self.involve.request.META["HTTP_REFERER"])

    @login_required
    def add_photo(self):
        photo_year = self.involve.request.GET.get("photo_year", "")
        photo_area = self.involve.request.GET.get("photo_area", "")
        photo_city = self.involve.request.GET.get("photo_city", "")
        photo_tag = self.involve.request.GET.get("photo_tag", "")

        print "photo_year:",[photo_year]
        print "photo_area:",[photo_area]
        print "photo_city:",[photo_city]
        print "photo_tag:",[photo_tag]

        if photo_year == "":
           return self.ajax_fail('year can not be empty!')
        elif photo_area == "":
           return self.ajax_fail('area can not be empty!')
        elif photo_city == "":
           return self.ajax_fail('city can not be empty!')

        ## check database if exist ##
        photo_exist = Photo.objects.filter(year=photo_year,area=photo_area,city=photo_city)
        if photo_exist:
           return ajax_fail("year:%s area:%s city:%s have been exists" % (photo_year, photo_area, photo_city))

        ## check year if exist ##
        year_exist = os.path.exists(os.path.join(settings.BASE_DIR, "static", "images", photo_year))
        if not year_exist:
           os.mkdir(os.path.join(settings.BASE_DIR, "static", "images", photo_year))

        ## check if area is exist ##
        area_exist = os.path.exists(os.path.join(settings.BASE_DIR, "static", "images", photo_year ,photo_area))
        if not area_exist:
           os.mkdir(os.path.join(settings.BASE_DIR,  "static", "images", photo_year, photo_area))

        city_exist = os.path.exists(os.path.join(settings.BASE_DIR, "static", "images", photo_year, photo_area, photo_city))
        if not city_exist:
           os.mkdir(os.path.join(settings.BASE_DIR, "static", "images", photo_year, photo_area, photo_city))

        one_photo = Photo()
        one_photo.year = photo_year
        one_photo.area = photo_area
        one_photo.city = photo_city
        one_photo.tag = photo_tag
        one_photo.save()

        return self.ajax_success("")

    @login_required
    def clear_img(self):
        ret = {}
        ret["ret"] = 0
        ret["msg"] = ""
        ret["data"] = {}
        ret["data"]["name"] = ""

        try:
            photo_year = self.involve.request.GET.get("photo_year", "")
            photo_area = self.involve.request.GET.get("photo_area", "")
            photo_city = self.involve.request.GET.get("photo_city", "")

            print "photo_year:",[photo_year]
            print "photo_area:",[photo_area]
            print "photo_city:",[photo_city]

            if photo_year == "":
                ret["ret"] = 1
                ret["msg"] = "photo_year is empty!"
            elif photo_area == "":
                ret["ret"] = 1
                ret["msg"] = "photo_area is empty!"
            elif photo_city == "":
                ret["ret"] = 1
                ret["msg"] = "photo_city is empty!"
            else:
                file_path = os.path.join(settings.BASE_DIR, "static", "images", 
                        photo_year, photo_area, photo_city)
                file_exist = os.path.exists(file_path)
                if file_exist:
                    shutil.rmtree(file_path)
                    os.mkdir(file_path)

        except:
            ret["ret"] = 1
            ret["msg"] = traceback.format_exc()
            traceback.print_exc()


        return ret

    @login_required
    def del_img(self):

        try:
            img_src = self.involve.request.GET.get("img_src", "") 
            print "img_src:",[img_src]

            if img_src == "":
                return self.location_fail('img src can not be empty!')

            img_exist = os.path.exists(settings.BASE_DIR + img_src)
            print "img_exist:",img_exist

            if img_exist:
                os.remove(settings.BASE_DIR + img_src)
            
        except:
            traceback.print_exc()
            return self.location_fail('del img exception!')

        return HttpResponseRedirect(self.involve.request.META["HTTP_REFERER"])

    @login_required
    def upload_img(self):
        print self.involve.request.FILES
        ret = {}
        ret["ret"] = 0
        ret["msg"] = ""
        ret["data"] = {}
        ret["data"]["name"] = ""

        try:
            photo_year = self.involve.request.GET.get("photo_year", "")
            photo_area = self.involve.request.GET.get("photo_area", "")
            photo_city = self.involve.request.GET.get("photo_city", "")
            img_file = self.involve.request.FILES.get("uploaded_file", "")
            ret["data"]["name"] = img_file.name

            print "photo_year:",[photo_year]
            print "photo_area:",[photo_area]
            print "photo_city:",[photo_city]

            if photo_year == "":
                ret["ret"] = 1
                ret["msg"] = "photo_year is empty!"
            elif photo_area == "":
                ret["ret"] = 1
                ret["msg"] = "photo_area is empty!"
            elif photo_city == "":
                ret["ret"] = 1
                ret["msg"] = "photo_city is empty!"
            else:
                file_path = os.path.join(settings.BASE_DIR, "static", "images", 
                        photo_year, photo_area, photo_city, img_file.name)
                file_exist = os.path.exists(file_path)
                if not file_exist:
                    fd = open(file_path, "wb")
                    fd.write(img_file.read())
                    fd.close()
        except:
            ret["ret"] = 1
            ret["msg"] = traceback.format_exc()
            traceback.print_exc()

        print ret
        return HttpResponse(json.dumps(ret))

    @login_required
    def update_img_tag(self):
        photo_id = self.involve.request.GET.get("photo_id", "")
        photo_img = self.involve.request.GET.get("photo_img", "")
        photo_tag = self.involve.request.GET.get("photo_tag", "")

        print "photo_id:", photo_id
        print "photo_img:", [photo_img]
        print "photo_tag:", [photo_tag]

        if not photo_id:
            return self.ajax_fail("photo_id can not be empty!")
        elif not photo_img:
            return self.ajax_fail("photo_img can not be empty!")
        elif not photo_tag:
            return self.ajax_fail("photo_tag can not be empty")

        try:
            psendword_list = list(Photo_Sendword.objects.filter(photo_id=photo_id).order_by("-create_time"))
            img_tags = list(Photo_Img_Tag.objects.filter(photo_id=photo_id,img_name=photo_img).order_by("-update_time"))
            if img_tags:
                one_img_tag = img_tags[0]
            else:
                one_img_tag = Photo_Img_Tag()
                one_img_tag.photo_id = photo_id
                one_img_tag.img_name = photo_img
            one_img_tag.tag_name = photo_tag
            one_img_tag.save()
        except:
            traceback.print_exc()
            return self.ajax_fail("update img tag exception!")

        return self.ajax_success("photo_id:%s photo_img:%s photo_tag:%s" % (photo_id, photo_img, photo_tag))
    def location_fail(self, alert_message):
        return HttpResponse( \
               "<script>alert(%s); \
                window.location.replace('%s');</script>" \
                 % (alert_message, self.involve.request.META["HTTP_REFERER"])  
               )

    def ajax_fail(self, ret_msg):
        ret = {}
        ret["ret"] = 1
        ret["msg"] = ret_msg
        print ret
        return HttpResponse(json.dumps(ret))

    def ajax_success(self, ret_msg):
        ret = {}
        ret["ret"] = 0
        ret["msg"] = ret_msg
        print ret
        return HttpResponse(json.dumps(ret))
